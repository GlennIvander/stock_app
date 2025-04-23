class HomeController < ApplicationController
  def index
    response = AvaApi.fetch_records(params[:symbol])
    @symbol = response["Meta Data"]["2. Symbol"]
    @stock_price = response.dig("Time Series (5min)").values.first.dig("1. open")
  end
end
