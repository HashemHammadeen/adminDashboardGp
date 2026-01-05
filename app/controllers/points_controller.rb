class PointsController < ApplicationController
  before_action :authenticate_mall_admin!

  def index
    @point_value = SystemConfiguration.point_value
    @expiration_days = SystemConfiguration.expiration_days
    
    # Stats
    @total_earned = EarnTransaction.sum(:points_earned)
    @total_redeemed = RedeemTransaction.sum(:points_used)
    
    # Recent activity
    @latest_earns = EarnTransaction.includes(:user, :shop).order(created_at: :desc).limit(10)
    @latest_redeems = RedeemTransaction.includes(:user, :shop).order(created_at: :desc).limit(10)
  end

  def update_rules
    SystemConfiguration.set('point_value', params[:point_value], 'Value of 1 point in currency')
    SystemConfiguration.set('expiration_days', params[:expiration_days], 'Days before points expire')
    
    # Also log history if value changed - assuming PointValueHistory exists as per migration name
    # Implementation of history logging is optional but good.
    
    redirect_to points_path, notice: "Point rules updated successfully."
  end
end
