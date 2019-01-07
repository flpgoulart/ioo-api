require 'rails_helper'

RSpec.describe OccupationArea, type: :model do

  let(:occupation_area) { build(:occupation_area) }

  it { is_expected.to have_many(:social_entities).dependent(:destroy) }

  it { is_expected.to validate_presence_of :name }
  
  # este passo é importante listar todos os campos previstos na aplicação, caso tenha algum não previsto, ele acusará no teste
  it { is_expected.to respond_to(:name) }
  
end