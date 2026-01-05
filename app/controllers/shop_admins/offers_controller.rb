module ShopAdmins
  class OffersController < BaseController
    before_action :set_offer, only: [:show, :edit, :update, :destroy, :activate, :deactivate]
    
    def index
      @offers = current_shop.offers.order(created_at: :desc)
    end

    def show
    end

    def new
      @offer = current_shop.offers.build
    end

    def edit
    end

    def create
      @offer = current_shop.offers.build(offer_params)
      
      if @offer.save
        redirect_to shop_admins_offers_path, notice: "Offer was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @offer.update(offer_params)
        redirect_to shop_admins_offers_path, notice: "Offer was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @offer.destroy
      redirect_to shop_admins_offers_path, notice: "Offer was successfully deleted."
    end

    def activate
      @offer.update(active: true)
      redirect_to shop_admins_offers_path, notice: "Offer activated."
    end

    def deactivate
      @offer.update(active: false)
      redirect_to shop_admins_offers_path, notice: "Offer deactivated."
    end

    private

    def set_offer
      @offer = current_shop.offers.find(params[:id])
    end

    def offer_params
      params.require(:offer).permit(:name, :description, :reward_type, :reward_value, :start_date, :end_date, :active)
    end
  end
end
