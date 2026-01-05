class UsersController < ApplicationController
  before_action :authenticate_mall_admin!
  load_and_authorize_resource
  before_action :set_user, only: [:show, :edit, :update, :destroy, :points]

  def index
    @users = User.includes(:tier, :user_points_balance).order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    @earn_transactions = @user.earn_transactions.includes(:shop).order(created_at: :desc).limit(10)
    @redeem_transactions = @user.redeem_transactions.includes(:shop).order(created_at: :desc).limit(10)
    @stamp_cards = @user.user_stamp_cards.includes(stamp: :shop)
  end

  def new
    @user = User.new
    @tiers = Tier.all
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserPointsBalance.create!(user_id: @user.id, total_points: 0, lifetime_points: 0)
      redirect_to @user, notice: 'User was successfully created.'
    else
      @tiers = Tier.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @tiers = Tier.all
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      @tiers = Tier.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully deleted.'
  end

  def points
    @balance = @user.user_points_balance
    @earn_history = @user.earn_transactions.includes(:shop).order(created_at: :desc)
    @redeem_history = @user.redeem_transactions.includes(:shop).order(created_at: :desc)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:firstname, :lastname, :phone, :email, :gender, :tier_id, :password_hash)
  end
end