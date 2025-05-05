# app/controllers/admin/transactions_controller.rb
class Admin::TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Fetch all transactions
    @transactions = Transaction.all
  end
end
