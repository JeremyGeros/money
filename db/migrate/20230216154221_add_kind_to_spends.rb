class AddKindToSpends < ActiveRecord::Migration[7.0]
  def change
    add_column :spends, :kind, :integer, default: 0, null: false
  end
end
