class StockPriceChangeColumnTypeInTransactions < ActiveRecord::Migration[8.0]
  def change
    change_column(:transactions, :stock_price, :float)
  end
end
