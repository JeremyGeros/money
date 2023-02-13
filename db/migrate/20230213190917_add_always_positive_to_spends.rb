class AddAlwaysPositiveToSpends < ActiveRecord::Migration[7.0]
  def change
    add_column :spends, :always_positive, :boolean, default: false
  end
end
