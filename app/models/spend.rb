class Spend < ApplicationRecord
  has_many :transactions, dependent: :nullify
  
  has_one_attached :icon do |attachable|
    attachable.variant :thumb, resize: "32x32^", gravity: "center", extent: "32x32"
  end

  after_save :match_existing_transactions!
  before_validation :normalize_lookups

  enum :category, {
    cafe: 0,
    restaurant: 1,
    supermarket: 2,
    gas: 3,
    pharmacy: 4,
    clothing: 5,
    electronics: 6,
    home: 7,
    taxis: 8,
    movies: 9,
    water: 10,
    power: 11,
    internet: 12,
    salary: 13,
    payment: 14,
    books: 15,
    tv: 16,
    web_services: 17,
    rent: 18,
    dairy: 19,
    insurance: 20,
    baby: 21,
    gaming: 22,
    other: 99,
  }, prefix: true

  enum :spend_group, {
    food: 0,
    shopping: 1,
    utilities: 2,
    income: 3,
    payments: 4,
    entertainment: 5,
    online_services: 6,
    transport: 7,
    insurance: 8,
    baby: 9,
    other: 99,
  }, prefix: true

  def normalize_lookups
    self.lookups = lookups.map(&:strip).compact.reject(&:blank?).uniq
  end

  def self.match_by_details(transaction, spends = nil)
    (spends || Spend.all).each do |spend|
      spend.lookups.each do |lookup|
        if transaction.details.downcase.include?(lookup.downcase)
          return spend
        end
      end
    end

    nil
  end

  def match_existing_transactions!
    @spends = Spend.all
    Transaction.where(spend: nil).each do |transaction|
      if (spend = Spend.match_by_details(transaction, @spends))
        transaction.spend = spend
        transaction.save!
      end
    end
  end
end
