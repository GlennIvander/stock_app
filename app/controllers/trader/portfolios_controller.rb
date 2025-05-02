class Trader::PortfoliosController < ApplicationController
  require "ostruct"
  before_action :authenticate_user!, except: [ :index ]

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
    grouped = current_user.portfolios.group_by(&:symbol)

    @merged_portfolios = grouped.map do |symbol, records|
      total_shares = records.sum(&:total_shares)
      total_cost   = records.sum(&:total_cost)

      OpenStruct.new(symbol: symbol, total_shares: total_shares, total_cost: total_cost)
    end
  end

  def create
    action = params[:commit]
    symbol = portfolio_params[:symbol]
    shares = portfolio_params[:total_shares].to_i
    price = portfolio_params[:stock_price].to_f

    existing_stock = current_user.portfolios.find_by(symbol: symbol)

    if action == "Sell"
      if existing_stock.total_shares < shares
        redirect_to trader_portfolios_path, alert: "You don't have enough shares to sell."
      else
        existing_stock.total_shares -= shares
        existing_stock.save

        Transaction.create(
          transaction_type: "sell",
          symbol: symbol,
          shares: shares,
          stock_price: price,
          total: price * shares,
          portfolio_id: existing_stock.id
        )

        current_user.balance += price * shares
        current_user.save

        if existing_stock.total_shares == 0
        end

        redirect_to trader_portfolios_path, notice: "Successfully sold #{shares} share(s) of #{symbol}."
      end

    else
      if existing_stock
        existing_stock.total_shares += shares
        existing_stock.total_cost += price * shares
        existing_stock.save
        total_cost = price * shares
      if current_user.balance < total_cost
        redirect_to trader_portfolios_path, alert: "Insufficient balance." and return
      end

      current_user.balance -= total_cost
      current_user.save

      else
        @stock = current_user.portfolios.new(
          symbol: symbol,
          stock_price: price,
          total_shares: shares,
          total_cost: price * shares
        )

        unless @stock.save
          redirect_to trader_portfolios_path, alert: "Failed to buy stock." and return
        end
      end

      Transaction.create(
        transaction_type: "buy",
        symbol: symbol,
        shares: shares,
        stock_price: price,
        total: price * shares,
        portfolio_id: existing_stock&.id || @stock.id
      )

      redirect_to trader_portfolios_path, notice: "Stock successfully bought!"
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
    @transactions = current_user.portfolios.flat_map(&:transactions)
  end

  private

  def portfolio_params
    params.require(:portfolio).permit(:symbol, :stock_price, :total_shares)
  end

  def set_id
    @portfolio= current_user.portfolios.find(params[:id])
  end
end
