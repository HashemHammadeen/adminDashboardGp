class DashboardController < ApplicationController
  before_action :authenticate_mall_admin!
  def index
    # 1. Key Metrics
    @total_users = User.count
    @active_users = User.where('updated_at >= ?', 30.days.ago).count # Approximation of active
    @total_points_issued = EarnTransaction.sum(:points_earned)
    @redeemed_points = RedeemTransaction.sum(:points_used)
    @outstanding_points = UserPointsBalance.sum(:total_points)
    
    # Redemption Rate: (Redeemed / Issued) * 100
    @redemption_rate = @total_points_issued > 0 ? ((@redeemed_points.to_f / @total_points_issued) * 100).round(2) : 0

    # 2. Financial Insights
    @point_value = SystemConfiguration.point_value
    @monetary_liability = @outstanding_points * @point_value
    
    # ROI Calculation (Simplified: Revenue from Earns - Cost of Redemptions)
    # Assuming purchase_amount is available in EarnTransaction
    total_revenue = EarnTransaction.sum(:purchase_amount)
    cost_of_redemptions = @redeemed_points * @point_value
    @roi = cost_of_redemptions > 0 ? ((total_revenue - cost_of_redemptions) / cost_of_redemptions * 100).round(2) : 0

    # 3. User Behavior Analytics (Charts)
    @points_earned_trend = EarnTransaction.group_by_day(:created_at, range: 30.days.ago..Time.now).sum(:points_earned)
    @points_redeemed_trend = RedeemTransaction.group_by_day(:created_at, range: 30.days.ago..Time.now).sum(:points_used)
    
    @user_growth = User.group_by_day(:created_at, range: 30.days.ago..Time.now).count
    
    @tier_distribution = User.joins(:tier).group('tiers.tier_name').count

    # 4. Reward Analytics
    @top_rewards = Offer.joins(:offer_redemptions)
                        .group(:id, :name)
                        .order('count(offer_redemptions.id) DESC')
                        .limit(5)
                        .count

    # 5. Expiration Monitoring (Mock/Simplified for now as we don't have per-point expiration yet)
    # Assuming points expire if no activity for X days, or based on specific logic not yet fully in DB
    expiration_days = SystemConfiguration.expiration_days
    @expiring_soon_count = User.where('updated_at < ?', (expiration_days - 30).days.ago).count # Users inactive for long time

    # 6. Recent Activity
    @recent_earnings = EarnTransaction.includes(:user, :shop).order(created_at: :desc).limit(10)
    @recent_redemptions = RedeemTransaction.includes(:user, :shop).order(created_at: :desc).limit(10)
  end
end