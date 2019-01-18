require 'rails_helper'

RSpec.describe ShoppingListOffer, type: :model do

  let(:shopping_list_offer) { build(:shopping_list_offer) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:offer) }
  it { is_expected.to belong_to(:shopping_list) }
  
  it { is_expected.to validate_presence_of :status }
  
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :offer_id }
  it { is_expected.to validate_presence_of :shopping_list_id }
  
  # este passo é importante listar todos os campos previstos na aplicação, caso tenha algum não previsto, ele acusará no teste
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:offer_id) }
  it { is_expected.to respond_to(:shopping_list_id) }
  it { is_expected.to respond_to(:user_id) }
  
  
 end
  