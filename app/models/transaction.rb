class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :spend, optional: true

  before_validation :set_defaults, on: :create


  validates :account, presence: true
  validates :amount, presence: true
  validates :currency, presence: true
  validates :made_at, presence: true


  def set_defaults
    self.currency ||= account.currency if account
    self.spend ||= Spend.match_by_details(self)

    if self.spend&.always_positive
      self.amount = self.amount.abs
    end
  end

  def pretty_name
    spend&.name || name.presence || 'UNKNOWN'
  end

  def category
    spend&.icon || spend&.category
  end


end
