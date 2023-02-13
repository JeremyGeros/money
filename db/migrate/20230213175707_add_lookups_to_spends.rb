class AddLookupsToSpends < ActiveRecord::Migration[7.0]
  def change
    add_column :spends, :lookups, :string, array: true, default: []
  end
end
