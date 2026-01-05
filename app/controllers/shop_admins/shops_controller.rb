module ShopAdmins
  class ShopsController < BaseController
    def show
      @shop = current_shop
      @wallet = @shop.shop_points_wallet
      @total_earned = @shop.earn_transactions.sum(:points_earned)
      @total_redeemed = @shop.redeem_transactions.sum(:points_used)
    end

    def edit
      @shop = current_shop
    end

    def update
      @shop = current_shop
      if @shop.update(shop_params)
        redirect_to shop_admins_shop_path, notice: "Shop settings updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def activate
      current_shop.update(is_active: true, status: :active)
      redirect_to shop_admins_shop_path, notice: "Shop activated."
    end

    def deactivate
      current_shop.update(is_active: false, status: :inactive)
      redirect_to shop_admins_shop_path, notice: "Shop deactivated."
    end

    private

    def shop_params
      params.require(:shop).permit(:name)
    end
  end
end
