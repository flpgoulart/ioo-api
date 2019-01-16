require 'rails_helper'

# este comando serve para descrever o que o teste
RSpec.describe 'Campaigns API', type: :request do
    before { host! 'api.ioo.test' }
    
    let!(:user) { create(:user) }
    let!(:auth_data) { user.create_new_auth_token }
    let(:headers) do 
        {
            'Accept' => 'application/vnd.ioo.v3',
            'Content-Type' => Mime[:json].to_s,
            'Authorization' => user.auth_token,
            'access-token' => auth_data['access-token'],
            'uid' => auth_data['uid'],
            'client' => auth_data['client']
        }
    end

    describe 'GET /campaigns' do

        context 'when no filter param is sent' do
        
            before do
                # é do FactoryGirl, serve para criar vários cadastros do mesmo objeto
                # neste caso, ele vai criar 5x, de acordo com o que foi parametrizado no factories/tasks
                create_list(:campaign, 5, user_id: user.id)
                get '/campaigns', params: {}, headers: headers 
            end
            
            it 'returns status code 200' do
                expect(response).to have_http_status(200)  
            end

            it 'returns 5 campaigns from database' do
                expect(json_body[:data].count).to eq(5)
            end
        
        end 

        context 'when filter and sorting params is sent' do
            let!(:notebook_se_1) { create(:campaign, name: 'Check if the notebook is broken', user_id: user.id ) }
            let!(:notebook_se_2) { create(:campaign, name: 'Buy a new notebook', user_id: user.id ) }
            let!(:other_se_1)    { create(:campaign, name: 'Fix the door', user_id: user.id ) }
            let!(:other_se_2)    { create(:campaign, name: 'Buy a new car', user_id: user.id ) }

            before do
                get '/campaigns?q[name_cont]=note&q[s]=name+ASC', params: {}, headers: headers
            end
            
            it 'returns only the campaigns matching and in the correct order' do
                returned_se_names = json_body[:data].map { |t| t[:attributes][:name] } #map serve para navegar entre os itens do array

                expect(returned_se_names).to eq([notebook_se_2.name, notebook_se_1.name])  
            end

        end

    end
    
    describe 'GET /campaigns/:id' do
        let(:campaign) {create(:campaign, user_id: user.id)}

        before { get "/campaigns/#{campaign.id}", params: {}, headers: headers }

        it 'returns status code 200' do
            expect(response).to have_http_status(200)
        end

        it 'returns the json for campaign' do
            expect(json_body[:data][:attributes][:name]).to eq(campaign.name)
        end
        
    end
    
    describe 'POST /campaigns' do
        before do
            post '/campaigns', params: { campaign: campaign_params }.to_json, headers: headers
        end
        
        context 'when the params are valid' do
            let(:campaign_params) { attributes_for(:campaign) } 

            it 'save the campaign in the database' do
                expect( Campaign.find_by( name: campaign_params[:name] ) ).not_to be_nil 
            end

            it 'returns the json for created campaign' do
                expect(json_body[:data][:attributes][:name]).to eq(campaign_params[:name])
            end

           it 'assigns the created campaign to the current user' do
               expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)
           end
        end

        context 'when the params are invalid' do
            let(:campaign_params) { attributes_for(:campaign, name: ' ') }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'does not save the campaign in the database' do
                expect( Campaign.find_by( name: campaign_params[:name] ) ).to be_nil 
            end

            # neste teste, ele especifica que quer especificamente o erro no titulo
            it 'returns the json errors for name' do
                expect(json_body[:errors]).to have_key(:name)
            end
        end
        
    end
    
    describe 'PUT /campaigns/:id' do
      let!(:campaign) { create(:campaign, user_id: user.id) }
      before do
          put "/campaigns/#{campaign.id}", params: { campaign: campaign_params }.to_json, headers: headers
      end
      
      context 'when the params are valid' do
          let(:campaign_params) { { name: 'New campaign name' } }

          it 'return status code 200' do
            expect(response).to have_http_status(200) 
          end

          it 'returns the json for updated campaign' do
            expect(json_body[:data][:attributes][:name]).to eq(campaign_params[:name])
          end

          it 'updates the campaign in the database' do 
            expect(Campaign.find_by(name: campaign_params[:name])).not_to be_nil 
          end
      end
    
      context 'when the params are invalid' do
          let(:campaign_params) { { name: ' ' } }

          it 'return status code 422' do
            expect(response).to have_http_status(422) 
          end

          it 'returns the json error for name' do
            expect(json_body[:errors]).to have_key(:name)
          end

          it 'does not update the campaign in the database' do
            expect( Campaign.find_by(name: campaign_params[:name]) ).to be_nil
          end
      end
      
    end

#     describe 'DELETE /campaigns/:id' do
#       let!(:campaign) { create(:campaign) }

#       before do
#           delete "/campaigns/#{campaign.id}", params: {}, headers: headers
#       end
      
#       it 'returns status code 204' do
#           expect(response).to have_http_status(204)
#       end

#       it 'removes the campaign from the database' do
#           expect{ StoreType.find(campaign.id) }.to raise_error(ActiveRecord::RecordNotFound)
#       end
#     end
end