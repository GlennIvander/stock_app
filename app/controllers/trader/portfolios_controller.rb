class Trader::PortfoliosController < ApplicationController
  before_action :authenticate_user!
  # before_action :correct_user, only: [ :edit, :update ]

  def index
    file_path = Rails.root.join("lib", "assets", "data.json")
    users = JSON.parse(File.read(file_path))
    # binding.b
    # response = AvaApi.fetch_records(params[:symbol])
    @symbol = users["Meta Data"]["2. Symbol"]
    @stock_price = users.dig("Time Series (5min)").values.first.dig("1. open")
    @traders = User.all
  end

  def new
  end
end
