class Spend < ApplicationRecord
  has_many :transactions, dependent: :nullify
  
  has_one_attached :icon do |attachable|
    attachable.variant :thumb, resize: "32x32^", gravity: "center", extent: "32x32"
  end

  after_save :match_existing_transactions!
  before_validation :normalize_lookups

  after_commit :update_transactions

  enum :category, {
    cafe: 0,
    restaurant: 1,
    supermarket: 2,
    utilities: 3,
    pharmacy: 4,
    clothing: 5,
    electronics: 6,
    home: 7,
    taxis: 8,
    movie_tv: 9,
    salary: 13,
    payment: 14,
    books: 15,
    web_services: 17,
    rent: 18,
    insurance: 20,
    baby: 21,
    gaming: 22,
    interest: 23,
    taxes: 24,
    delivery_food: 25,
    bus: 26,
    health: 27,
    travel: 28,
    other: 99,

    transfer: 100,
    bank_fees: 101,
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
    health: 8,
    baby: 9,
    travel: 10,
    other: 99,
    transfer: 100,
    bank_fees: 101,
  }, prefix: true

  enum kind: { transaction: 0, one_off: 1, recurring: 2 }, _prefix: :kind

  def normalize_lookups
    self.lookups = lookups.map(&:strip).compact.reject(&:blank?).uniq
  end

  def update_transactions
    if previous_changes["always_positive"] && always_positive
      transactions.update_all(amount: Arel.sql('ABS(amount)'))
    end

    if previous_changes["ignored"] && ignored
      transactions.update_all(ignored: ignored)
    end

    if previous_changes["category"] && category == "transfer"
      transactions.update_all(personal_transfer: true)
    end

    if previous_changes["kind"]
      if kind == "one_off"
        transactions.update_all(kind: "one_off")
      elsif kind == "recurring"
        transactions.update_all(kind: "recurring")
      elsif kind == "transaction"
        transactions.update_all(kind: "transaction")
      end
    end
  end

  def transfer?
    category == "transfer"
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
        
        if spend.always_positive
          transaction.amount = transaction.amount.abs
        end

        if spend.ignored
          transaction.ignored = true
        end

        if spend.kind == "one_off"
          transaction.kind = "one_off"
        elsif spend.kind == "recurring"
          transaction.kind = "recurring"
        end

        transaction.save!
      end
    end
  end
end
