class ChangeAllowEmptyReplacer < ActiveRecord::Migration[7.0]
  def change
    change_column :matchers, :replacer, :string, null: true
  end
end
