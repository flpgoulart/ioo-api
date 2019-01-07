require 'rails_helper'

RSpec.describe SocialEntity, type: :model do

  let(:social_entity) { build(:social_entity) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:occupation_area) }
  it { is_expected.to belong_to(:target_audience) }

  it { is_expected.to have_many(:improvements).dependent(:destroy) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :address }
  it { is_expected.to validate_presence_of :you_are_a }
  
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :target_audience_id }
  it { is_expected.to validate_presence_of :occupation_area_id }
  
  # este passo é importante listar todos os campos previstos na aplicação, caso tenha algum não previsto, ele acusará no teste
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:you_are_a) }
  it { is_expected.to respond_to(:facebook_url) }
  it { is_expected.to respond_to(:address_comp) }
  it { is_expected.to respond_to(:cnpj_no) }
  it { is_expected.to respond_to(:about_us) }
  it { is_expected.to respond_to(:phone_number) }
  it { is_expected.to respond_to(:mobile_number) }
  it { is_expected.to respond_to(:email_contact) }
  it { is_expected.to respond_to(:site) }
  it { is_expected.to respond_to(:address) }
  it { is_expected.to respond_to(:user_id) }
  it { is_expected.to respond_to(:target_audience_id) }
  it { is_expected.to respond_to(:occupation_area_id) }
  
end
