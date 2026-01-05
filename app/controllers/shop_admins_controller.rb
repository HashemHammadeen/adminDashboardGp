class ShopAdminsController < ApplicationController
  before_action :authenticate_mall_admin!
  before_action :set_shop

  def create
    @shop_admin = @shop.shop_admins.build(shop_admin_params)
    # Default password if not provided or handle via email invite logic (simplified here)
    @shop_admin.password ||= "password123" 
    
    if @shop_admin.save
      redirect_to @shop, notice: "Shop Admin added successfully."
    else
      redirect_to @shop, alert: "Error adding admin: #{@shop_admin.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @shop_admin = @shop.shop_admins.find(params[:id])
    @shop_admin.destroy
    redirect_to @shop, notice: "Shop Admin removed successfully."
  end

  private

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end

  def shop_admin_params
    params.require(:shop_admin).permit(:name, :email, :phone, :password, :password_confirmation)
  end
end
