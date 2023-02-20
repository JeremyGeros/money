class MatcherTransaction < ApplicationRecord
  belongs_to :matched_transaction, class_name: 'Transaction', foreign_key: :transaction_id
  belongs_to :matcher

  validates :original_name, presence: true
  validates :new_name, presence: true
end
