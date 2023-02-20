class AddGenericToSpends < ActiveRecord::Migration[7.0]
  def change
    add_column :spends, :generic, :boolean, default: false, null: false
  end
end
