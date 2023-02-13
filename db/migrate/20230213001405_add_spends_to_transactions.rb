class AddSpendsToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :spend_id, :integer, null: true, foreign_key: true
  end
end
