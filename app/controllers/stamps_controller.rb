class StampsController < ApplicationController
  before_action :authenticate_mall_admin!
  load_and_authorize_resource
  before_action :set_stamp, only: %i[ show edit update destroy ]

  def index
    @stamps = Stamp.all
  end

  def show
  end

  def new
    @stamp = Stamp.new
  end

  def edit
  end

  def create
    @stamp = Stamp.new(stamp_params)
    @stamp.reward_value = { "value" => params[:stamp][:reward_value_input] }

    if @stamp.save
      redirect_to @stamp, notice: "Stamp was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @stamp.reward_value = { "value" => params[:stamp][:reward_value_input] }

    if @stamp.update(stamp_params)
      redirect_to @stamp, notice: "Stamp was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @stamp.destroy!

    redirect_to stamps_url, notice: "Stamp was successfully destroyed."
  end

  private
    def set_stamp
      @stamp = Stamp.find(params[:id])
    end

    def stamp_params
      params.require(:stamp).permit(:name, :description, :shop_id, :start_date, :end_date, :expiration_limit, :stamps_required, :stamps_limit, :active, :reward_type)
    end
end
