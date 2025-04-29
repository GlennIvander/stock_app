class Trader::PortfoliosController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  # before_action :correct_user, only: [ :edit, :update ]

  def index
    @traders = User.all
  end

  def new
    file_path = Rails.root.join("lib", "assets", "data.json")
    users = JSON.parse(File.read(file_path))
    # binding.b
    # response = AvaApi.fetch_records(params[:symbol])
    @symbol = users["Meta Data"]["2. Symbol"]
    @stock_price = users.dig("Time Series (5min)").values.first.dig("1. open")
    @stock = current_user.portfolios.new
    @traders = User.all
  end

  def show; end
end
