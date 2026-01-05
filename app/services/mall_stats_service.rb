class MallStatsService
  def initialize(mall)
    @mall = mall
  end

  def stats
    {
      shops_count: @mall.shops.count,
      active_shops_count: @mall.shops.where(is_active: true).count,
      total_sales: total_sales,
      total_points_issued: total_points_issued,
      total_redeemed: total_redeemed
    }
  end

  private

  def total_sales
    EarnTransaction.where(shop_id: @mall.shops.select(:id)).sum(:purchase_amount)
  end

  def total_points_issued
    EarnTransaction.where(shop_id: @mall.shops.select(:id)).sum(:points_earned)
  end

  def total_redeemed
    RedeemTransaction.where(shop_id: @mall.shops.select(:id)).sum(:points_used)
  end
end
