require 'rails_helper'

RSpec.describe ShoppingList, type: :model do

  let(:shopping_list) { build(:shopping_list) }

  it { is_expected.to belong_to(:user) }
  
  it { is_expected.to have_many(:shopping_list_offers).dependent(:destroy) }
  
  it { is_expected.to validate_presence_of :name }
  
  it { is_expected.to validate_presence_of :user_id }
  
  # este passo é importante listar todos os campos previstos na aplicação, caso tenha algum não previsto, ele acusará no teste
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:user_id) }


end
