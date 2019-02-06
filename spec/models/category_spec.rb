require 'rails_helper'

RSpec.describe Category, type: :model do

  let(:category) { build(:category) }

  it { is_expected.to have_many(:subcategories).dependent(:destroy) }
  it { is_expected.to have_many(:personal_pages).dependent(:destroy) }


  it { is_expected.to validate_presence_of :name }
  
  # este passo é importante listar todos os campos previstos na aplicação, caso tenha algum não previsto, ele acusará no teste
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:logo) }
  

end
