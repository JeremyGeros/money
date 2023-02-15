class AddPersonalTransferToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :personal_transfer, :boolean, default: false, null: false
  end
end
