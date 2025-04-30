class RemoveNameFromTableTransaction < ActiveRecord::Migration[8.0]
  def change
    remove_column :transactions, :name, :string
  end
end
