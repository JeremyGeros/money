class CreateMatchers < ActiveRecord::Migration[7.0]
  def change
    create_table :matchers do |t|
      t.references :account, null: false, foreign_key: true
      t.string :match_regex, null: false
      t.string :replacer, null: false
      t.datetime :enabled_at

      t.timestamps
    end
  end
end
