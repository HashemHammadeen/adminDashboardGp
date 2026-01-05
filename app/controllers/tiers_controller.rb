class TiersController < ApplicationController
  before_action :authenticate_mall_admin!
  load_and_authorize_resource
  def index
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
