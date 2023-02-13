class Account < ApplicationRecord
  has_many :transactions, dependent: :destroy
  has_many :imports, dependent: :destroy

  validates :name, presence: true
  validates :currency, presence: true
  validates :bank, presence: true
  validates :account_number, presence: true

  has_one_attached :logo do |attachable|
    attachable.variant :thumb, resize: "100x100^", gravity: "center", extent: "100x100"
  end

  enum currency: { mxn: 0, usd: 1, nzd: 2 }

  def balance
    starting_balance + transactions.sum(:amount)
  end

  def balance_at(date)
    starting_balance + transactions.where('made_at <= ?', date).sum(:amount)
  end

  def balance_change(from_date, to_date)
    balance_at(to_date) - balance_at(from_date)
  end

end

