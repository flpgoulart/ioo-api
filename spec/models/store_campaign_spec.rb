require 'rails_helper'

RSpec.describe StoreCampaign, type: :model do

  
  let(:store_campaign) { build(:store_campaign) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:store) }
  it { is_expected.to belong_to(:campaign) }

  #it { is_expected.to have_many(:products).dependent(:destroy) }
  

  it { is_expected.to validate_presence_of :status }
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :store_id }
  it { is_expected.to validate_presence_of :campaign_id }
  
  # este passo é importante listar todos os campos previstos na aplicação, caso tenha algum não previsto, ele acusará no teste
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:user_id) }
  it { is_expected.to respond_to(:store_id) }
  it { is_expected.to respond_to(:campaign_id) }

end
