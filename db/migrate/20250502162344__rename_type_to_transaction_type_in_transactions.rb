class RenameTypeToTransactionTypeInTransactions < ActiveRecord::Migration[8.0]
  def change
    rename_column :transactions, :type, :transaction_type
  end
end
