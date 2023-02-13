class AddNameRfcToTransactions < ActiveRecord::Migration[7.0]
  def change

    add_column :transactions, :name, :string
    add_column :transactions, :rfc, :string
    add_column :transactions, :balance, :float

    add_column :spends, :full_details, :string


  end
end
