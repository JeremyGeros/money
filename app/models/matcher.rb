class Matcher < ApplicationRecord
  belongs_to :account

  has_many :matcher_transactions, dependent: :destroy
  has_many :transactions, through: :matcher_transactions, source: :matched_transaction
  
  validates :match_regex, presence: true
  validates :account, presence: true

  scope :enabled, -> { where.not(enabled_at: nil) }

  after_save :match_existing_transactions!

  def self.match_by_name(transaction)
    matchers = Matcher.enabled.where(account: transaction.account)
    matchers.each do |matcher|
      matcher.check_and_update(transaction)
    end
  end

  def replacer
    replacer || ''
  end

  def enabled=(value)
    if value.present?
      self.enabled_at = Time.now
    else
      self.enabled_at = nil
    end
  end

  def check_and_update(transaction)
    if enabled_at.present? && transaction.name =~ /#{match_regex}/i
      matcher_transaction = matcher_transactions.new(original_name: transaction.name)

      transaction.name = transaction.name.gsub(/#{match_regex}/i, replacer)
      matcher_transaction.new_name = transaction.name
      matcher_transaction.matched_transaction = transaction
      
      matcher_transaction.save!
      transaction.save!
    end
  end

  def match_existing_transactions!
    if enabled_at.present?
      Transaction.where(account: account).each do |transaction|
        check_and_update(transaction)
      end
    end
  end
end
