class PortfoliosController < ApplicationController
  # before_action :authenticate_user!, except: [ :index, :show ]
  # before_action :correct_user, only: [ :edit, :update ]

  def index
    file_path = Rails.root.join("lib / tasks", "assets", "data.json")
    users = JSON.parse(File.read(file_path))
    # response = AvaApi.fetch_records(params[:symbol])
    @symbol = response["Meta Data"]["2. Symbol"]
    @stock_price = response.dig("Time Series (5min)").values.first.dig("1. open")
  end

  def search
  end
end
