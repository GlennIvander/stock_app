class AddTotalCostToPortfoliosTable < ActiveRecord::Migration[8.0]
  def change
    add_column :portfolios, :total_cost, :float
  end
end
