require 'rails_helper'

RSpec.describe VolunteerList, type: :model do

  let(:volunteer_list) { build(:volunteer_list) }

  it { is_expected.to belong_to(:volunteer) }
  it { is_expected.to belong_to(:improvement) }
  
  it { is_expected.to validate_presence_of :volunteer_id }
  it { is_expected.to validate_presence_of :improvement_id }
  
  # este passo é importante listar todos os campos previstos na aplicação, caso tenha algum não previsto, ele acusará no teste
  it { is_expected.to respond_to(:volunteer_id) }
  it { is_expected.to respond_to(:improvement_id) }
  it { is_expected.to respond_to(:attendance) }
  it { is_expected.to respond_to(:rate_volunteer) }
  it { is_expected.to respond_to(:rate_improvement) }
  it { is_expected.to respond_to(:rate_social_entity) }
  
end
