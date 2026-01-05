module ShopAdmins
  class RedemptionsController < BaseController
    def index
      @redemptions = current_shop.redeem_transactions.includes(:user).order(created_at: :desc).page(params[:page])
    end

    def new
      # QR Scan page
    end

    def create
      # Find user by QR code (assuming QR contains user_id or verification code)
      user = find_user_from_qr(params[:qr_code])
      
      if user.nil?
        redirect_to new_shop_admins_redemption_path, alert: "Invalid QR code. User not found."
        return
      end

      points_to_redeem = params[:points].to_i
      user_balance = user.user_points_balance&.total_points || 0
      
      # Validation
      if points_to_redeem <= 0
        redirect_to new_shop_admins_redemption_path, alert: "Please enter valid points amount."
        return
      end

      if points_to_redeem > user_balance
        redirect_to new_shop_admins_redemption_path, alert: "Insufficient balance. User has #{user_balance} points."
        return
      end

      # Calculate discount value
      point_value = SystemConfiguration.point_value
      discount_value = points_to_redeem * point_value

      # Create redemption transaction
      verification_code = SecureRandom.hex(3).upcase

      ActiveRecord::Base.transaction do
        # Create redeem transaction
        @redemption = RedeemTransaction.create!(
          user: user,
          shop: current_shop,
          points_used: points_to_redeem,
          discount_value: discount_value,
          verification_code: verification_code,
          status: 'completed',
          completed_at: Time.current
        )

        # Update user balance
        user.user_points_balance.update!(
          total_points: user_balance - points_to_redeem
        )

        # Update shop wallet
        wallet = current_shop.shop_points_wallet
        wallet.update!(
          points_received: wallet.points_received + points_to_redeem
        ) if wallet
      end

      redirect_to shop_admins_redemptions_path, notice: "Redeemed #{points_to_redeem} points for #{number_to_currency(discount_value)} discount. Code: #{verification_code}"
    rescue ActiveRecord::RecordInvalid => e
      redirect_to new_shop_admins_redemption_path, alert: "Error: #{e.message}"
    end

    private

    def find_user_from_qr(qr_code)
      # QR code could be user_id, email, or special token
      # For simplicity, assume it's user_id or email
      User.find_by(id: qr_code) || User.find_by(email: qr_code)
    end
  end
end
