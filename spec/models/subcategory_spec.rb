require 'rails_helper'

RSpec.describe Subcategory, type: :model do

  let(:subcategory) { build(:subcategory) }

  #it { is_expected.to have_many(:stores).dependent(:destroy) }
  it { is_expected.to belong_to(:category) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :category_id }
  
  # este passo é importante listar todos os campos previstos na aplicação, caso tenha algum não previsto, ele acusará no teste
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:logo) }
  it { is_expected.to respond_to(:category_id) }
  it { is_expected.to respond_to(:market_session) }
  

end
