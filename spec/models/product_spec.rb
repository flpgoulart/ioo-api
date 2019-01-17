require 'rails_helper'

RSpec.describe Product, type: :model do

  let(:product) { build(:product) }

  it { is_expected.to have_many(:offers).dependent(:destroy) }
  
  it { is_expected.to belong_to(:subcategory) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :subcategory_id }
  
  # este passo é importante listar todos os campos previstos na aplicação, caso tenha algum não previsto, ele acusará no teste
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:keywords) }
  it { is_expected.to respond_to(:logo_default) }
  it { is_expected.to respond_to(:subcategory_id) }
  

end
