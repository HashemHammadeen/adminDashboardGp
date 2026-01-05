class ShopsController < ApplicationController
  before_action :authenticate_mall_admin!
  load_and_authorize_resource
  before_action :set_shop, only: [:show, :edit, :update, :destroy, :analytics, :approve, :activate, :deactivate]

  def approve
    @shop.update(status: :approved)
    redirect_back(fallback_location: shop_path(@shop), notice: "Shop approved.")
  end

  def activate
    @shop.update(status: :active, is_active: true)
    redirect_back(fallback_location: shop_path(@shop), notice: "Shop activated.")
  end

  def deactivate
    @shop.update(status: :inactive, is_active: false)
    redirect_back(fallback_location: shop_path(@shop), notice: "Shop deactivated.")
  end

  def index
    @shops = Shop.includes(:mall, :categories).with_attached_logo.page(params[:page]).per(20)
  end

  def show
    @offers = @shop.offers.order(created_at: :desc).limit(5)
    @stamps = @shop.stamps.order(created_at: :desc).limit(5)
    @recent_transactions = @shop.earn_transactions.order(created_at: :desc).limit(10)
  end

  def new
    @shop = Shop.new
    @malls = Mall.all
    @categories = Category.all
  end

  def create
    @shop = Shop.new(shop_params)
    if @shop.save
      ShopPointsWallet.create!(shop_id: @shop.id, points_received: 0)
      redirect_to @shop, notice: 'Shop was successfully created.'
    else
      @malls = Mall.all
      @categories = Category.all
      render :new
    end
  end

  def edit
    @malls = Mall.all
    @categories = Category.all
  end

  def update
    if @shop.update(shop_params)
      redirect_to @shop, notice: 'Shop was successfully updated.'
    else
      @malls = Mall.all
      @categories = Category.all
      render :edit
    end
  end

  def destroy
    @shop.destroy
    redirect_to shops_url, notice: 'Shop was successfully deleted.'
  end

  def analytics
    @wallet = @shop.shop_points_wallet
    @total_earnings = @shop.earn_transactions.sum(:points_earned)

    # Check if redeem_transactions uses 'points_used' or 'points_redeemed'
    # based on your previous errors
    @total_redemptions = @shop.redeem_transactions.sum(:points_used)

    # Grouping by day (PostgreSQL version)
    @monthly_earnings = @shop.earn_transactions
                             .where('created_at >= ?', 30.days.ago)
                             .group("DATE(created_at)")
                             .order("DATE(created_at) ASC")
                             .sum(:points_earned)
  end

  private

  def set_shop
    @shop = Shop.find(params[:id])
  end

  def shop_params
    params.require(:shop).permit(:name, :mall_id, :is_active, :logo, category_ids: [])
  end
end