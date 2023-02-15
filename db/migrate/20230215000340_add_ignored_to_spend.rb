class AddIgnoredToSpend < ActiveRecord::Migration[7.0]
  def change
    add_column :spends, :ignored, :boolean, default: false, null: false
  end
end
