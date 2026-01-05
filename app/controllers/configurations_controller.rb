class ConfigurationsController < ApplicationController
  def index
    @point_value = SystemConfiguration.get('point_value', 0.01)
    @expiration_days = SystemConfiguration.get('expiration_days', 365)
    @history = PointValueHistory.order(effective_date: :desc).limit(20)
  end

  def update
    key = params[:key]
    value = params[:value]
    
    case key
    when 'point_value'
      old_value = SystemConfiguration.point_value
      new_value = value.to_f
      
      if old_value != new_value
        SystemConfiguration.set('point_value', new_value, "Updated by admin")
        
        PointValueHistory.create!(
          admin_id: nil, # TODO: Add current_admin.id if available
          old_value: old_value,
          new_value: new_value,
          reason: params[:reason] || "Manual update",
          effective_date: Time.now
        )
        flash[:notice] = "Point value updated successfully."
      end
    when 'expiration_days'
      SystemConfiguration.set('expiration_days', value.to_i, "Updated by admin")
      flash[:notice] = "Expiration policy updated successfully."
    end

    redirect_to configurations_path
  end
end
