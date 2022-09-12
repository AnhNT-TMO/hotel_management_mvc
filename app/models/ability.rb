# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize user
    can :read, Room
    can [:read, :create, :destroy], Booking, user_id: user.id
    can :read, Bill, user_id: user.id
    can :manage, User, id: user.id
    can :read, :basket
    can :read, :history

    return unless user.admin?

    can :manage, :all
  end
end
