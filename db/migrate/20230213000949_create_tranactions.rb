class CreateTranactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :account, null: false, foreign_key: true

      t.datetime :made_at
      t.string :details
      t.float :amount

      t.boolean :ignored, null: false, default: false

      t.integer :currency, null: false, default: 0
      
      t.integer :kind, null: false, default: 0

      t.integer :status, null: false, default: 0
      
      t.timestamps
    end
  end
end
