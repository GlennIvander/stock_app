class TotalChangeColumnTypeInTransactions < ActiveRecord::Migration[8.0]
  def change
    change_column(:transactions, :total, :float)
  end
end
