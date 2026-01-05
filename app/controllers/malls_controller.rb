class MallsController < ApplicationController
  before_action :authenticate_mall_admin!
  load_and_authorize_resource
  before_action :set_mall, only: %i[ show edit update destroy ]

  def index
    @malls = Mall.all
  end

  def show
    @stats = MallStatsService.new(@mall).stats
  end

  def new
    @mall = Mall.new
  end

  def edit
  end

  def create
    @mall = Mall.new(mall_params)

    if @mall.save
      redirect_to @mall, notice: "Mall was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @mall.update(mall_params)
      redirect_to @mall, notice: "Mall was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @mall.destroy!

    redirect_to malls_url, notice: "Mall was successfully destroyed."
  end

  private
    def set_mall
      @mall = Mall.find(params[:id])
    end

    def mall_params
      params.require(:mall).permit(:mall_name, :location)
    end
end
