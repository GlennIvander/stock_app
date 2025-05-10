class Portfolio < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy

  validates :total_shares, presence: true, numericality: { only_integer: true }
end
