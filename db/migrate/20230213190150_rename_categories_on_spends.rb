class RenameCategoriesOnSpends < ActiveRecord::Migration[7.0]
  def change
    rename_column :spends, :small_category, :category
    rename_column :spends, :big_category, :spend_group
  end
end
