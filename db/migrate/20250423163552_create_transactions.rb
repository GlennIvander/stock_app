class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.string :type
      t.string :name
      t.string :symbol
      t.integer :shares
      t.integer :stock_price
      t.integer :total
      t.references :portfolio, null: false, foreign_key: true

      t.timestamps
    end
  end
end
