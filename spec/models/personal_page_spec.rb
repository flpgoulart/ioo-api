require 'rails_helper'

RSpec.describe PersonalPage, type: :model do

  let(:personal_page) { build(:personal_page) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:category) }

  it { is_expected.to validate_presence_of :category_id }
  it { is_expected.to validate_presence_of :user_id }
  
  # este passo é importante listar todos os campos previstos na aplicação, caso tenha algum não previsto, ele acusará no teste
  it { is_expected.to respond_to(:user_id) }
  it { is_expected.to respond_to(:category_id) }


end
