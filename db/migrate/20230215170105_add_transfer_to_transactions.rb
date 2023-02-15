class AddTransferToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :transfer_transaction_id, :integer, foreign_key: true
  end
end
