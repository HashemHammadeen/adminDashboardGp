module ShopAdmins
  class DashboardController < BaseController
    def index
      @shop = current_shop
      
      # Key metrics
      @total_points_earned = @shop.earn_transactions.sum(:points_earned)
      @total_points_redeemed = @shop.redeem_transactions.sum(:points_used)
      @total_transactions = @shop.earn_transactions.count + @shop.redeem_transactions.count
      @total_sales = @shop.earn_transactions.sum(:purchase_amount)
      
      # Recent transactions
      @recent_earns = @shop.earn_transactions.includes(:user).order(created_at: :desc).limit(5)
      @recent_redeems = @shop.redeem_transactions.includes(:user).order(created_at: :desc).limit(5)
      
      # Active offers and stamps
      @active_offers = @shop.offers.where(active: true).limit(5)
      @active_stamps = @shop.stamps.where(active: true).limit(5)

      # Charts Data
      @points_activity = (0..30).map { |i| i.days.ago.to_date }.reverse.map do |date|
        {
          date: date.strftime("%b %d"),
          earned: @shop.earn_transactions.where(created_at: date.all_day).sum(:points_earned),
          redeemed: @shop.redeem_transactions.where(created_at: date.all_day).sum(:points_used)
        }
      end

      @top_offers = @shop.offers.order(redemptions_count: :desc).limit(5).pluck(:name, :redemptions_count)
    end
  end
end
