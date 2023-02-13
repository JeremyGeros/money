class RenameBanorteImportsToImports < ActiveRecord::Migration[7.0]
  def change
    rename_table :banorte_imports, :imports
  end
end
