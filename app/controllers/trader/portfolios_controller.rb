class Trader::PortfoliosController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_id, only: %i[show]

  def index
    @portfolios = current_user.portfolios
    @stock = current_user.portfolios.new
    @traders = User.all

    if params[:symbol].present?
      users = AvaApi.fetch_records(params[:symbol])
      if users.present? && users["Meta Data"].present? && users["Time Series (5min)"].present?
        @symbol = users["Meta Data"]["2. Symbol"]
        @stock_price = users["Time Series (5min)"].values.first["1. open"]
      else
        flash.now[:alert] = "Symbol not found or API error."
      end
    end
  end

  def new
    # file_path = Rails.root.join("lib", "assets", "data.json")
    # users = JSON.parse(File.read(file_path))
    # binding.b
    # @name = users[]
  end

  def my_portfolio
    @portfolios = current_user.portfolios
  end

  def create
    @stock = current_user.portfolios.new(portfolio_params)

    if @stock.save
      redirect_to trader_portfolios_path, notice: "Stock successfully bought!"
    else
      redirect_to trader_portfolios_path, alert: "Failed to buy stock."
    end
  end

  def sell
    @portfolio = current_user.portfolios.find(params[:id])
    shares_to_sell = params[:shares_to_sell].to_i

    if shares_to_sell <= 0
      redirect_to trader_my_portfolio_path, alert: "Invalid number of shares."
    elsif shares_to_sell > @portfolio.total_shares
      redirect_to trader_my_portfolio_path, alert: "You don't have that many shares to sell."
    else
      @portfolio.total_shares -= shares_to_sell
      if @portfolio.total_shares == 0
        @portfolio.destroy
        redirect_to trader_my_portfolio_path, notice: "All shares sold. Stock removed from your portfolio."
      else
        @portfolio.save
        redirect_to trader_my_portfolio_path, notice: "Successfully sold #{shares_to_sell} share(s)."
      end
    end
  end

  def transaction
  end

  def show; end

  private

  def portfolio_params
    params.require(:portfolio).permit(:symbol, :stock_price, :total_shares)
  end

  def set_id
    @portfolio= current_user.portfolios.find(params[:id])
  end
end
