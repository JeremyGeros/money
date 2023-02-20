class CreateMatcherTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :matcher_transactions do |t|
      t.references :transaction, null: false, foreign_key: true
      t.references :matcher, null: false, foreign_key: true

      t.string :original_name, null: false
      t.string :new_name, null: false

      t.timestamps
    end
  end
end
