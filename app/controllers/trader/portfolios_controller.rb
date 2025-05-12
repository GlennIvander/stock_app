class Trader::PortfoliosController < ApplicationController
  require "ostruct"
  before_action :authenticate_user!

  def index
    @portfolios = current_user.portfolios
    @stock = current_user.portfolios.new
    @users = User.all

    @major_stocks = {
      "Microsoft" => "MSFT",
      "Google"    => "GOOG",
      "Netflix"   => "NFLX",
      "Amazon"    => "AMZN",
      "Meta"      => "META"
    }

    @stock_totals = {}

    @major_stocks.each do |name, symbol|
      total = Transaction.where(symbol: symbol, transaction_type: "buy").sum(:shares)
      @stock_totals[symbol] = total
    end

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
      total_cost = records.sum { |r| r.stock_price * r.total_shares }

      OpenStruct.new(symbol: symbol, total_shares: total_shares, total_cost: total_cost, created_at: records.min_by(&:created_at).created_at)
    end
  end

  def create
    action = params[:commit]
    symbol = portfolio_params[:symbol]
    shares = portfolio_params[:total_shares].to_i
    price = portfolio_params[:stock_price].to_f
    total_cost = shares * price
    stock = current_user.portfolios.find_or_initialize_by(symbol: symbol)

    if action == "Sell"
      handle_sell(stock, shares, price)
    else
      handle_buy(stock, shares, price, total_cost)
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
        @portfolio.save
        redirect_to trader_my_portfolio_path, notice: "All shares sold. You no longer hold any shares of this stock."
      else
        @portfolio.save
        redirect_to trader_my_portfolio_path, notice: "Successfully sold #{shares_to_sell} share(s)."
      end
    end
  end

  private

  def portfolio_params
    params.require(:portfolio).permit(:symbol, :stock_price, :total_shares)
  end

  def handle_sell(stock, shares, price)
    if stock.new_record? || stock.total_shares < shares
      redirect_to trader_portfolios_path, alert: "You don't have enough shares to sell." and return
    end

    stock.total_shares -= shares
    stock.total_cost -= price * shares
    stock.save

    create_transaction("sell", stock, shares, price)

    current_user.balance += price * shares
    current_user.save

    redirect_to trader_portfolios_path, notice: "Successfully sold #{shares} share(s) of #{stock.symbol}."
  end

  def handle_buy(stock, shares, price, total_cost)
    if current_user.balance.to_f < total_cost.to_f
      redirect_to trader_portfolios_path, alert: "Insufficient balance." and return
    end

    stock.total_shares ||= 0
    stock.total_cost ||= 0

    stock.total_shares += shares
    stock.total_cost += total_cost

    stock.stock_price = stock.total_cost / stock.total_shares.to_f
    stock.save!

    create_transaction("buy", stock, shares, price)

    current_user.balance -= total_cost
    current_user.save

    redirect_to trader_portfolios_path, notice: "Stock successfully bought!"
  end

  def create_transaction(type, stock, shares, price)
    Transaction.create!(
      transaction_type: type,
      symbol: stock.symbol,
      shares: shares,
      stock_price: price,
      total: price * shares,
      portfolio_id: stock.id
    )
  end
end
