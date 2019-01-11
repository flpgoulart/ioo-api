class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.user_type==="A"
      can :manage, :all
    else
      can :manage, :all
    end
  end
end
