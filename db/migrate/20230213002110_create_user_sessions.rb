class CreateUserSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :key
      t.datetime :accessed_at

      t.timestamps
    end
    add_index :user_sessions, :key, unique: true
  end
end
