require 'rails_helper'

RSpec.describe Campaign, type: :model do

  let(:campaign) { build(:campaign) }

  it { is_expected.to belong_to(:user) }
  
  it { is_expected.to have_many(:offers).dependent(:destroy) }
  it { is_expected.to have_many(:store_campaigns).dependent(:destroy) }
  
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :start_date }
  it { is_expected.to validate_presence_of :end_date }
  it { is_expected.to validate_presence_of :status }
  
  it { is_expected.to validate_presence_of :user_id }
  
  # este passo é importante listar todos os campos previstos na aplicação, caso tenha algum não previsto, ele acusará no teste
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:disclaimer) }
  it { is_expected.to respond_to(:start_date) }
  it { is_expected.to respond_to(:end_date) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:user_id) }


end
