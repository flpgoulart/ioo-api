require 'rails_helper'

RSpec.describe Billing, type: :model do

  let(:billing) { build(:billing) }

  it { is_expected.to belong_to(:user) }
  
  it { is_expected.to validate_presence_of :document }
  it { is_expected.to validate_presence_of :doc_date }
  it { is_expected.to validate_presence_of :ref_ini_date }
  it { is_expected.to validate_presence_of :ref_end_date }
  it { is_expected.to validate_presence_of :link_document }
  it { is_expected.to validate_presence_of :status }
  it { is_expected.to validate_presence_of :user_id }
  
  # este passo é importante listar todos os campos previstos na aplicação, caso tenha algum não previsto, ele acusará no teste
  it { is_expected.to respond_to(:document) }
  it { is_expected.to respond_to(:doc_date) }
  it { is_expected.to respond_to(:ref_ini_date) }
  it { is_expected.to respond_to(:ref_end_date) }
  it { is_expected.to respond_to(:link_document) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:user_id) }

end
