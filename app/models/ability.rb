class Ability
  include CanCan::Ability

  def initialize user
    can :read, [Room, Booking]

    return if user.nil?

    can :read, Room
    can [:read, :create, :destroy], Booking, user_id: user.id
    can :read, Bill, user_id: user.id
    can :read, User, id: user.id
    can [:read, :destroy], :basket
    can :read, :history

    return unless user.admin?

    can :manage, :all
  end
end
