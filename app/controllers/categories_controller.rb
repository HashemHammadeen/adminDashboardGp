class CategoriesController < ApplicationController
  before_action :authenticate_mall_admin!
  load_and_authorize_resource
  before_action :set_category, only: %i[ show edit update destroy ]

  def index
    @categories = Category.all.order(active: :desc, category_name: :asc)
  end

  def show
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    @category.active = true 

    if @category.save
      redirect_to categories_url, notice: "Category was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to categories_url, notice: "Category was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.soft_delete
    redirect_to categories_url, notice: "Category was successfully deactivated."
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:category_name, :description, :active)
  end
end
