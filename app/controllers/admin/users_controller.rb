class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [ :show, :edit, :update, :destroy, :approve ]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.is_admin = false # Ensure the user is created as a trader
    @user.is_pending = false # Mark as approved immediately if desired

    if @user.save
      # Portfolio.create(user_id: @user.id, symbol: "USD", stock_price: 0, total_shares: 0)

      UserMailer.admin_created_email(@user).deliver

      redirect_to admin_user_path(@user), notice: "Trader created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "Trader updated successfully."
    else
      render :edit
    end
  end

  def pending
    @pending_users = User.where(is_pending: true)
  end

  def approve
    @user = User.find(params[:id])
    if @user.update(is_pending: false)
      # Portfolio.create(user_id: @user.id, symbol: "USD", stock_price: 0, total_shares: 0)

      UserMailer.welcome_email(@user).deliver_now

      redirect_to admin_users_path, notice: "Trader approved and email sent."
    else
      redirect_to admin_users_path, alert: "Failed to approve trader."
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to admin_users_path, notice: "Trader deleted successfully."
    else
      redirect_to admin_users_path, alert: "Failed to delete trader."
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :balance, :is_pending)
  end
end
