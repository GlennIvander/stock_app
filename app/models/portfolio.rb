class Portfolio < ApplicationRecord
  belongs_to :user
  has_many :transactions

  def total_cost
    stock_price.to_f * total_shares.to_i
  end
end
