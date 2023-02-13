class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :bank, null: false
      t.string :name, null: false
      t.string :account_number
      t.integer :currency, null: false, default: 0

      t.timestamps
    end
  end
end
