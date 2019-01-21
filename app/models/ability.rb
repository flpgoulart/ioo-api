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
      elsif user.user_type==="E"
        can :manage, ShoppingList, user_id: user.id
        can :manage, ShoppingListOffer, user_id: user.id
        can :manage, Business, user_id: user.id
        can :manage, Campaign, user_id: user.id
        can :manage, Offer, user_id: user.id
        can :manage, Store, user_id: user.id
        can :manage, StoreCampaign, user_id: user.id
      elsif user.user_type==="B"
        can :manage, ShoppingList, user_id: user.id
        can :manage, ShoppingListOffer, user_id: user.id
        can :manage, Business, user_id: user.id
        can :manage, Campaign, user_id: user.id
        can :manage, Offer, user_id: user.id
        can :manage, Store, user_id: user.id
        can :manage, StoreCampaign, user_id: user.id
        #can :manage, Reports
      end
    end
  end
end
 

# Business
# Campaign
# Offer
# Store
# StoreCampaign
# ShoppingList
# ShoppingListOffer
# Report 