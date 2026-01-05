class CampaignsController < ApplicationController
  before_action :authenticate_mall_admin!
  load_and_authorize_resource
  before_action :set_campaign, only: [:show, :edit, :update, :destroy]

  def index
    @campaigns = Campaign.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @campaign = Campaign.new
    @shops = Shop.all
  end

  def edit
    @shops = Shop.all
  end

  def create
    @campaign = Campaign.new(campaign_params)

    if @campaign.save
      redirect_to @campaign, notice: "Campaign was successfully created."
    else
      @shops = Shop.all
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @campaign.update(campaign_params)
      redirect_to @campaign, notice: "Campaign was successfully updated."
    else
      @shops = Shop.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @campaign.destroy
    redirect_to campaigns_url, notice: "Campaign was successfully destroyed."
  end

  private

  def set_campaign
    @campaign = Campaign.find(params[:id])
  end

  def campaign_params
    params.require(:campaign).permit(:name, :description, :start_date, :end_date, :status, :shop_id)
  end
end
