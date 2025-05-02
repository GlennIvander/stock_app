class RemoveNameFromPortfolio < ActiveRecord::Migration[8.0]
  def change
    remove_column :portfolios, :name, :string
  end
end
