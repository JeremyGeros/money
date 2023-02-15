class Account < ApplicationRecord
  has_many :transactions, dependent: :destroy
  has_many :imports, dependent: :destroy

  validates :name, presence: true
  validates :currency, presence: true
  validates :bank, presence: true

  has_one_attached :logo do |attachable|
    attachable.variant :thumb, resize: "100x100^", gravity: "center", extent: "100x100"
  end

  enum currency: { mxn: 0, usd: 1, nzd: 2 }

  def balance
    starting_balance + transactions.sum(:amount)
  end

  def balance_at(date)
    starting_balance + transactions.where('made_at <= ?', date).not_personal_transfer.sum(:amount)
  end

  def balance_change(from_date, to_date)
    balance_at(to_date) - balance_at(from_date)
  end

  def spent_between(from_date, to_date, spend: nil, to_currency: nil)
    _t = transactions.between(from_date, to_date).not_personal_transfer.where('amount < 0')
    _t = _t.where(spend: spend) if spend
    sum_to_currency(_t.sum(:amount), to_currency: to_currency)
  end

  def made_between(from_date, to_date, spend: nil, to_currency: nil)
    _t = transactions.between(from_date,to_date).not_personal_transfer.where('amount > 0')
    sum_to_currency(_t.sum(:amount), to_currency: to_currency)
  end

  def sum_to_currency(sum, to_currency: nil)
    if to_currency && to_currency != currency
      Money.from_amount(sum, currency).exchange_to(to_currency).to_f
    else
      sum
    end
  end

end

