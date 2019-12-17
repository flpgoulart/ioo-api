class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    
    if user.user_type==="A"
      can :manage, :all
    else
      if user.user_type==="U"
        can :manage, ShoppingList, user_id: user.id
        can :manage, ShoppingListOffer, user_id: user.id
        can :manage, PersonalPage, user_id: user.id
      elsif user.user_type==="E" #Plano Free com limitação
        can :manage, ShoppingList, user_id: user.id
        can :manage, ShoppingListOffer, user_id: user.id
        can :manage, Business, user_id: user.id
        can :manage, Campaign, user_id: user.id
        can :manage, Offer, user_id: user.id
        can :manage, Store, user_id: user.id
        can :manage, StoreCampaign, user_id: user.id
        can :manage, BusinessAccount, user_id: user.id
        can :read, Billing, user_id: user.id
		can :read, City
		can :read, StoreType
		can :read, UnitMeasure
		can :read, Product
      elsif user.user_type==="B" #Plano Full
        can :manage, ShoppingList, user_id: user.id
        can :manage, ShoppingListOffer, user_id: user.id
        can :manage, Business, user_id: user.id
        can :manage, Campaign, user_id: user.id
        can :manage, Offer, user_id: user.id
        can :manage, Store, user_id: user.id
        can :manage, StoreCampaign, user_id: user.id
        can :manage, BusinessAccount, user_id: user.id
        can :read, Billing, user_id: user.id
		can :read, City
		can :read, StoreType
		can :read, UnitMeasure
		can :read, Product
      end
    end
  end
end
 
