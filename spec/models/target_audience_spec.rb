require 'rails_helper'

RSpec.describe TargetAudience, type: :model do

  let(:target_audience) { build(:target_audience) }

  it { is_expected.to have_many(:social_entities).dependent(:destroy) }

  it { is_expected.to validate_presence_of :name }
  
  # este passo é importante listar todos os campos previstos na aplicação, caso tenha algum não previsto, ele acusará no teste
  it { is_expected.to respond_to(:name) }
  
end