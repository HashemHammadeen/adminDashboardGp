class OffersController < ApplicationController
  before_action :authenticate_mall_admin!
  load_and_authorize_resource
  before_action :set_offer, only: %i[ show edit update destroy ]

  def index
    @offers = Offer.all
  end

  def show
  end

  def new
    @offer = Offer.new
  end

  def edit
  end

  def create
    @offer = Offer.new(offer_params)
    # Manually construct the JSONB reward_value
    @offer.reward_value = { "value" => params[:offer][:reward_value_input] }

    if @offer.save
      redirect_to @offer, notice: "Offer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    # Update reward_value manually before normal update
    @offer.reward_value = { "value" => params[:offer][:reward_value_input] }
    
    if @offer.update(offer_params)
      redirect_to @offer, notice: "Offer was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @offer.destroy!

    redirect_to offers_url, notice: "Offer was successfully destroyed."
  end

  private
    def set_offer
      @offer = Offer.find(params[:id])
    end

    def offer_params
      params.require(:offer).permit(:name, :description, :shop_id, :start_date, :end_date, :active, :reward_type)
    end
end
