class SessionsController < ApplicationController
  layout "auth", only: [:new, :create]

  def new
    redirect_to root_path if logged_in?
  end

  def create
    user = MallAdmin.find_by(email: params[:email]) || ShopAdmin.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:admin_id] = user.id
      session[:admin_type] = user.class.name
      redirect_to root_path, notice: "Logged in successfully!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:admin_id] = nil
    session[:admin_type] = nil
    redirect_to login_path, notice: "Logged out successfully!"
  end

  private

  def logged_in?
    session[:admin_id].present?
  end
end
