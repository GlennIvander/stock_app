class StockPriceChangeColumnTypeInPortfolios < ActiveRecord::Migration[8.0]
  def change
    change_column(:portfolios, :stock_price, :float)
  end
end
