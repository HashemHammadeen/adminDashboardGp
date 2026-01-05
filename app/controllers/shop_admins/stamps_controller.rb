module ShopAdmins
  class StampsController < BaseController
    before_action :set_stamp, only: [:show, :edit, :update, :destroy, :activate, :deactivate]
    
    def index
      @stamps = current_shop.stamps.order(created_at: :desc)
    end

    def show
    end

    def new
      @stamp = current_shop.stamps.build
    end

    def edit
    end

    def create
      @stamp = current_shop.stamps.build(stamp_params)
      
      if @stamp.save
        redirect_to shop_admins_stamps_path, notice: "Stamp program was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @stamp.update(stamp_params)
        redirect_to shop_admins_stamps_path, notice: "Stamp program was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @stamp.destroy
      redirect_to shop_admins_stamps_path, notice: "Stamp program was successfully deleted."
    end

    def activate
      @stamp.update(active: true)
      redirect_to shop_admins_stamps_path, notice: "Stamp program activated."
    end

    def deactivate
      @stamp.update(active: false)
      redirect_to shop_admins_stamps_path, notice: "Stamp program deactivated."
    end

    private

    def set_stamp
      @stamp = current_shop.stamps.find(params[:id])
    end

    def stamp_params
      params.require(:stamp).permit(:name, :description, :stamps_required, :reward_type, :reward_value, :start_date, :end_date, :expiration_limit, :stamps_limit, :active)
    end
  end
end
