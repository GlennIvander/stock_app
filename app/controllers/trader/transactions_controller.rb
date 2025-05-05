class Trader::TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @transactions = current_user.portfolios.includes(:transactions).flat_map(&:transactions)
  end
end
