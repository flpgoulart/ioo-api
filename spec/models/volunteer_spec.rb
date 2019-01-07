require 'rails_helper'

RSpec.describe Volunteer, type: :model do

  let(:volunteer) { build(:volunteer) }

  it { is_expected.to belong_to(:user) }
  
  it { is_expected.to have_many(:volunteer_lists).dependent(:destroy) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :address }
  
  it { is_expected.to validate_presence_of :user_id }
  
  # este passo é importante listar todos os campos previstos na aplicação, caso tenha algum não previsto, ele acusará no teste
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:address) }
  it { is_expected.to respond_to(:address_comp) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:user_id) }
  
end
