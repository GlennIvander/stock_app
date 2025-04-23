class CreatePortfolios < ActiveRecord::Migration[8.0]
  def change
    create_table :portfolios do |t|
      t.string :name
      t.string :symbol
      t.integer :stock_price
      t.integer :total_shares
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
