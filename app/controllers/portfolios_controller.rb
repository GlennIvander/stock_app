class PortfoliosController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :correct_user, only: [ :edit, :update ]

  def index
    response = AvaApi.fetch_records(params[:symbol])
    @symbol = response["Meta Data"]["2. Symbol"]
    @stock_price = response.dig("Time Series (5min)").values.first.dig("1. open")
  end
end
