class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :spend, optional: true

  has_many :matcher_transactions, dependent: :destroy
  has_many :matchers, through: :matcher_transactions

  belongs_to :transfer_transaction, class_name: 'Transaction', optional: true, foreign_key: :transfer_transaction_id

  before_validation :set_defaults, on: :create


  validates :account, presence: true
  validates :amount, presence: true
  validates :currency, presence: true
  validates :made_at, presence: true

  scope :between, ->(from_date, to_date) { where(made_at: from_date..to_date) }
  scope :not_personal_transfer, -> { where(personal_transfer: false).where(transfer_transaction_id: nil) }
  scope :personal_transfer, -> { where(personal_transfer: true)or(where.not(transfer_transaction_id: nil)) }
  scope :has_spend, -> { where.not(spend: nil) }

  default_scope { where(ignored: false) }

  after_commit :try_to_match_transfer
  after_commit :run_matchers, on: :create

  enum kind: { transaction: 0, one_off: 1, recurring: 2 }, _prefix: :kind


  def set_defaults
    self.currency ||= account.currency if account
    self.spend ||= Spend.match_by_details(self)

    if self.spend&.always_positive
      self.amount = self.amount.abs
    end

    if self.spend&.ignored
      self.ignored = true
    end

    if self.spend&.transfer?
      self.personal_transfer = true
    end
  end

  def run_matchers
    Matcher.match_by_name(self)
  end

  def try_to_match_transfer
    if self.transfer_transaction.present?
      if transfer_transaction.transfer_transaction_id != self.id
        transfer_transaction.transfer_transaction = self
        transfer_transaction.personal_transfer = true
        transfer_transaction.save!
      end
    elsif personal_transfer
      accounts_to_search = Account.where.not(id: account.id)
      accounts_to_search.each do |to_account|
        amount_to_search = Money.from_amount(amount, account.currency).exchange_to(to_account.currency).to_f * -1

        # Search for a transaction in the other account that matches the amount and date with a tolerance of $200 and 1 week
        matched = Transaction
          .where(account: to_account)
          .where(amount: (amount_to_search - 200.0)..(amount_to_search + 200.0))
          .where(made_at: (made_at - 1.week)..(made_at + 1.week))
          .where.not(id: id)
          .where(transfer_transaction_id: nil)
          .first
        
        if matched
          Rails.logger.info "Matched transfer transaction #{id} for $#{amount} #{account.currency} with #{matched.id} for $#{matched.amount} #{to_account.currency}}"
          self.transfer_transaction = matched
          self.save!
          matched.transfer_transaction = self
          matched.personal_transfer = true
          matched.save!
          break
        end
      end
    end
  end

  def pretty_name
    if spend&.generic
      "#{spend.name} (#{name})"
    elsif spend
      spend.name
    elsif name.present?
      name
    else
      'UNKNOWN'
    end
  end

  def category
    spend&.icon || spend&.category
  end

  def color_override
    if transfer_transaction
      'text-sky-500'
    end
  end


end
