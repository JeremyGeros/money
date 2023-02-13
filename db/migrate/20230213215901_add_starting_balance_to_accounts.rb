class AddStartingBalanceToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :starting_balance, :float, default: 0
  end
end
