class CreateSpends < ActiveRecord::Migration[7.0]
  def change
    create_table :spends do |t|
      t.string :name
      t.integer :small_category, null: false, default: 0
      t.integer :big_category, null: false, default: 0

      t.timestamps
    end
  end
end
