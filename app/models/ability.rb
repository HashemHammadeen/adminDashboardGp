# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the user here.
    # The user can be a MallAdmin, ShopAdmin, or nil (guest).

    return unless user.present?

    if user.is_a?(MallAdmin)
      # Mall Admin can manage everything
      can :manage, :all
    elsif user.is_a?(ShopAdmin)
      # Shop Admin can only manage their own shop and related resources
      can :read, Shop, id: user.shop_id
      can :update, Shop, id: user.shop_id
      can :activate, Shop, id: user.shop_id
      can :deactivate, Shop, id: user.shop_id

      # Shop Admin can manage Offers in their shop
      can :manage, Offer, shop_id: user.shop_id

      # Shop Admin can manage Stamps in their shop
      can :manage, Stamp, shop_id: user.shop_id

      # Shop Admin can view and create transactions for their shop
      can :read, EarnTransaction, shop_id: user.shop_id
      can :read, RedeemTransaction, shop_id: user.shop_id
      can :create, RedeemTransaction, shop_id: user.shop_id

      # Shop Admin can view their shop's analytics
      can :analytics, Shop, id: user.shop_id
    end
  end
end
