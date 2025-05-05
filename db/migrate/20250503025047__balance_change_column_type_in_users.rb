class BalanceChangeColumnTypeInUsers < ActiveRecord::Migration[8.0]
  def change
    change_column(:users, :balance, :float)
  end
end
