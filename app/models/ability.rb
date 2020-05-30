# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Not signed user
    user ||= User.new

    # Super admin
    can :manage, :all if user.super_admin?

    # Admin and Sales
    if user.admin?
      can :manage, [Order, Product, Provider, Charter]
    else
      can :read, [Order, Product, Provider, Charter]
    end
  end
end
