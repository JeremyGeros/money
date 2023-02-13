class CreateBanorteImport < ActiveRecord::Migration[7.0]
  def change
    create_table :banorte_imports do |t|
      t.string :name

      t.references :account, null: false, foreign_key: true

      t.integer :status, default: 0, null: false

      t.integer :total_transactions

      t.timestamps
    end
  end
end
