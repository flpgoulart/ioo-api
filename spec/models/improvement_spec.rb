require 'rails_helper'

RSpec.describe Improvement, type: :model do
 
  let(:improvement) { build(:improvement) }

  it { is_expected.to belong_to(:social_entity) }

  it { is_expected.to have_many(:volunteer_lists).dependent(:destroy) }

	it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :short_description }
  it { is_expected.to validate_presence_of :address }
  it { is_expected.to validate_presence_of :limit_volunteers }
  it { is_expected.to validate_presence_of :start_date }
  it { is_expected.to validate_presence_of :end_date }
  it { is_expected.to validate_presence_of :status }
  it { is_expected.to validate_presence_of :people_benefited }
  

  it { is_expected.to validate_presence_of :social_entity_id }
  
  # este passo é importante listar todos os campos previstos na aplicação, caso tenha algum não previsto, ele acusará no teste  
  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:short_description) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:address) }
  it { is_expected.to respond_to(:address_comp) }
  it { is_expected.to respond_to(:limit_volunteers) }
  it { is_expected.to respond_to(:start_date) }
  it { is_expected.to respond_to(:end_date) }
  it { is_expected.to respond_to(:knowledge_required) }
  it { is_expected.to respond_to(:support_materials) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:people_benefited) }
  it { is_expected.to respond_to(:social_entity_id) }
  
end
