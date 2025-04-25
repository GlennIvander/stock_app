require "test_helper"

class PortfolioControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get portfolio_index_url
    assert_response :success
  end
end
