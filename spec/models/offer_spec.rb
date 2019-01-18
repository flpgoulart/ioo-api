require 'rails_helper'

RSpec.describe Offer, type: :model do

  let(:offer) { build(:offer) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:product) }
  it { is_expected.to belong_to(:campaign) }
  it { is_expected.to belong_to(:unit_measure) }

  it { is_expected.to have_many(:shopping_list_offers).dependent(:destroy) }
  
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :product_id }
  it { is_expected.to validate_presence_of :campaign_id }
  it { is_expected.to validate_presence_of :unit_measure_id }
  it { is_expected.to validate_presence_of :product_value }
  it { is_expected.to validate_presence_of :offer_value }
  it { is_expected.to validate_presence_of :brand_name }
  
  # este passo é importante listar todos os campos previstos na aplicação, caso tenha algum não previsto, ele acusará no teste
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:user_id) }

  it { is_expected.to respond_to(:brand_name) }
  it { is_expected.to respond_to(:product_id) }
  it { is_expected.to respond_to(:campaign_id) }
  it { is_expected.to respond_to(:disclaimer) }
  it { is_expected.to respond_to(:unit_measure_id) }
  it { is_expected.to respond_to(:product_value) }
  it { is_expected.to respond_to(:offer_value) }


end
