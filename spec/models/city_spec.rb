require 'rails_helper'

RSpec.describe City, type: :model do

  let(:city) { build(:city) }

  it { is_expected.to have_many(:stores).dependent(:destroy) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :uf }
  it { is_expected.to validate_presence_of :cep_begin }
  it { is_expected.to validate_presence_of :cep_end }
  
  # este passo é importante listar todos os campos previstos na aplicação, caso tenha algum não previsto, ele acusará no teste
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:uf) }
  it { is_expected.to respond_to(:cep_begin) }
  it { is_expected.to respond_to(:cep_end) }
  

end
