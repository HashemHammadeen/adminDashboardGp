class ProfilesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin

  def show
  end

  def update
    if @admin.update(admin_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      render :show, status: :unprocessable_entity
    end
  end

  def update_password
    if @admin.update(password_params)
      redirect_to profile_path, notice: "Password changed successfully."
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_admin
    @admin = current_admin
  end

  def admin_params
    params.require(:admin).permit(:name, :email, :phone)
  end

  def password_params
    params.require(:admin).permit(:password, :password_confirmation)
  end
end
