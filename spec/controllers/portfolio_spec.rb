require 'rails_helper'

RSpec.describe PortfoliosController, type: :controller do
  let(:user) { create(:user, is_pending: false) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "assigns the user's portfolios" do
      portfolio = create(:portfolio, user: user, total_shares: 100)

      get :index

      expect(assigns(:portfolios)).to include(portfolio)
    end
  end
end
