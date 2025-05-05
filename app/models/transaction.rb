class Transaction < ApplicationRecord
  belongs_to :portfolio

  validates :transaction_type, presence: true
  validates :symbol, presence: true
  validates :shares, presence: true
  validates :stock_price, presence: true
  validates :total, presence: true
end
