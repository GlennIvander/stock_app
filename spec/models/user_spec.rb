require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validation' do
    it 'does not accept password that has no special character ' do
      user = FactoryBot.build(:user)
      expect(user).not_to be_valid
    end
  end
end
