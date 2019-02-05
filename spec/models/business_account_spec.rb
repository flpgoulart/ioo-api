require 'rails_helper'

RSpec.describe BusinessAccount, type: :model do

  let(:business_account) { build(:business_account) }

  it { is_expected.to belong_to(:user) }
  
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :cnpj }
  it { is_expected.to validate_presence_of :city_name }
  it { is_expected.to validate_presence_of :uf }
  it { is_expected.to validate_presence_of :ddd_mobile }
  it { is_expected.to validate_presence_of :mobile }
  it { is_expected.to validate_presence_of :address_name }
  it { is_expected.to validate_presence_of :cep }
  it { is_expected.to validate_presence_of :plan }
  it { is_expected.to validate_presence_of :status }
  
  # este passo é importante listar todos os campos previstos na aplicação, caso tenha algum não previsto, ele acusará no teste
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:cnpj) }
  it { is_expected.to respond_to(:insce) }
  it { is_expected.to respond_to(:inscm) }
  it { is_expected.to respond_to(:city_name) }
  it { is_expected.to respond_to(:uf) }
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:ddd_phone) }
  it { is_expected.to respond_to(:phone) }
  it { is_expected.to respond_to(:ddd_mobile) }
  it { is_expected.to respond_to(:mobile) }
  it { is_expected.to respond_to(:address_name) }
  it { is_expected.to respond_to(:cep) }
  it { is_expected.to respond_to(:plan) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:user_id) }

end
