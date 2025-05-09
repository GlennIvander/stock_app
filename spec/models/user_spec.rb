require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validation' do
    it 'does not accept password that has no special character ' do
      password = User.new(email: "sample@email.com", password: "password")
      expect(password).not_to be_valid
    end
  end
end
