class RemoveRfcColumnOnTransactions < ActiveRecord::Migration[7.0]
  def change
    remove_column :transactions, :rfc
  end
end
