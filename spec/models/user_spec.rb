require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:portfolios) }
    it { should have_many(:transactions).through(:portfolios) }
  end

  describe "validations" do
    it "is invalid without a special character in the password" do
      user = User.new(email: "test@example.com", password: "Password1", password_confirmation: "Password1")
      user.valid?
      expect(user.errors[:password]).to include("must include at least one special character (e.g., !@#$%^&*)")
    end

    it "is valid with a special character in the password" do
      user = User.new(email: "test@example.com", password: "Password@1", password_confirmation: "Password@1")
      expect(user).to be_valid
    end
  end

  describe "roles" do
    it "returns true for admin if is_admin is true" do
      user = User.new(is_admin: true)
      expect(user.admin?).to be true
      expect(user.trader?).to be false
    end

    it "returns true for trader if is_admin is false" do
      user = User.new(is_admin: false)
      expect(user.trader?).to be true
      expect(user.admin?).to be false
    end
  end
end
