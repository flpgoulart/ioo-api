require 'rails_helper'

RSpec.describe Business, type: :model do

  let(:business) { build(:business) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:stores).dependent(:destroy) }
  
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :user_id }
  
  # este passo é importante listar todos os campos previstos na aplicação, caso tenha algum não previsto, ele acusará no teste
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:about_us) }
  it { is_expected.to respond_to(:url_site) }
  it { is_expected.to respond_to(:url_facebook) }
  it { is_expected.to respond_to(:contact_info) }
  it { is_expected.to respond_to(:user_id) }


end
