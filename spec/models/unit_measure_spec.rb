require 'rails_helper'

RSpec.describe UnitMeasure, type: :model do

  let(:unit_measure) { build(:unit_measure) }

  it { is_expected.to have_many(:offers).dependent(:destroy) }

  it { is_expected.to validate_presence_of :name }
  
  # este passo é importante listar todos os campos previstos na aplicação, caso tenha algum não previsto, ele acusará no teste
  it { is_expected.to respond_to(:name) }

end
