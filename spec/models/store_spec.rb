require 'rails_helper'

RSpec.describe Store, type: :model do

  let(:store) { build(:store) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:store_type) }
  it { is_expected.to belong_to(:business) }
  it { is_expected.to belong_to(:city) }

  it { is_expected.to have_many(:store_campaigns).dependent(:destroy) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :store_type_id }
  it { is_expected.to validate_presence_of :business_id }
  it { is_expected.to validate_presence_of :city_id }
  it { is_expected.to validate_presence_of :cep }
  it { is_expected.to validate_presence_of :address_name }
  it { is_expected.to validate_presence_of :status }
  
  # este passo é importante listar todos os campos previstos na aplicação, caso tenha algum não previsto, ele acusará no teste
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:user_id) }

  it { is_expected.to respond_to(:store_type_id) }
  it { is_expected.to respond_to(:business_id) }
  it { is_expected.to respond_to(:city_id) }
  it { is_expected.to respond_to(:cep) }
  it { is_expected.to respond_to(:address_name) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:contact_info) }

end
