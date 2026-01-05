class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # CanCanCan exception handling
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, alert: exception.message }
      format.json { render json: { error: exception.message }, status: :forbidden }
    end
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone, :mall_id, :shop_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :phone])
  end

  helper_method :current_admin, :mall_admin?, :shop_admin?

  def current_admin
    current_mall_admin || current_shop_admin
  end

  def mall_admin?
    current_mall_admin.present?
  end

  def shop_admin?
    current_shop_admin.present?
  end

  # Override current_ability for CanCanCan to use our admin
  def current_ability
    @current_ability ||= Ability.new(current_admin)
  end

  protected

  # Devise redirect paths
  def after_sign_in_path_for(resource)
    if resource.is_a?(MallAdmin)
      root_path # Mall admin goes to main dashboard
    elsif resource.is_a?(ShopAdmin)
      shop_admins_root_path # Shop admin goes to their dashboard
    else
      root_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    case resource_or_scope
    when :mall_admin
      new_mall_admin_session_path
    when :shop_admin
      new_shop_admin_session_path
    else
      root_path
    end
  end
end
