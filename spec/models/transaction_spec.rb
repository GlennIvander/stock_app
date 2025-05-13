require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'associations' do
    it { should belong_to(:portfolio) }
  end

  describe 'validations' do
    it { should validate_presence_of(:transaction_type) }
    it { should validate_presence_of(:symbol) }
    it { should validate_presence_of(:shares) }
    it { should validate_presence_of(:stock_price) }
    it { should validate_presence_of(:total) }
  end
end
