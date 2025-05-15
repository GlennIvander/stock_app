class Admin::TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Fetch all transactions
    @users = User.all
    @transactions = Transaction.all
  end
end
