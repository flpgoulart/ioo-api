require 'rails_helper'

# este comando serve para descrever o que o teste
RSpec.describe 'Store Campaigns API', type: :request do
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

    describe 'GET /store_campaigns' do

        context 'when no filter param is sent' do
        
            before do
                # é do FactoryGirl, serve para criar vários cadastros do mesmo objeto
                # neste caso, ele vai criar 5x, de acordo com o que foi parametrizado no factories/tasks
                create_list(:store_campaign, 5, user_id: user.id)
                get '/store_campaigns', params: {}, headers: headers 
            end
            
            it 'returns status code 200' do
                expect(response).to have_http_status(200)  
            end

            it 'returns 5 store campaigns from database' do
                expect(json_body[:data].count).to eq(5)
            end
        
        end 

        # context 'when filter and sorting params is sent' do
        #     let!(:notebook_se_1) { create(:store_campaign, name: 'Check if the notebook is broken', user_id: user.id ) }
        #     let!(:notebook_se_2) { create(:store_campaign, name: 'Buy a new notebook', user_id: user.id ) }
        #     let!(:other_se_1)    { create(:store_campaign, name: 'Fix the door', user_id: user.id ) }
        #     let!(:other_se_2)    { create(:store_campaign, name: 'Buy a new car', user_id: user.id ) }

        #     before do
        #         get '/store_campaigns?q[name_cont]=note&q[s]=name+ASC', params: {}, headers: headers
        #     end
            
        #     it 'returns only the store campaigns matching and in the correct order' do
        #         returned_se_names = json_body[:data].map { |t| t[:attributes][:name] } #map serve para navegar entre os itens do array

        #         expect(returned_se_names).to eq([notebook_se_2.name, notebook_se_1.name])  
        #     end

        # end

    end
    
    describe 'GET /store_campaigns/:id' do
        let(:store_campaign) {create(:store_campaign, user_id: user.id)}

        before { get "/store_campaigns/#{store_campaign.id}", params: {}, headers: headers }

        it 'returns status code 200' do
            expect(response).to have_http_status(200)
        end

        it 'returns the json for store campaign' do
            expect(json_body[:data][:attributes][:status]).to eq(store_campaign.status)
        end
        
    end
    
    describe 'POST /store_campaigns' do
        before do
            post '/store_campaigns', params: { store_campaign: store_campaign_params }.to_json, headers: headers
        end
        
        context 'when the params are valid' do

            let(:store) { create(:store)}
            let(:campaign) { create(:campaign)}
            let(:store_campaign_params) { attributes_for(:store_campaign, store_id: store.id, campaign_id: campaign.id ) } 

            it 'save the store campaign in the database' do
                expect( StoreCampaign.find_by( status: store_campaign_params[:status] ) ).not_to be_nil 
            end

            it 'returns the json for created store campaign' do
                expect(json_body[:data][:attributes][:status]).to eq(store_campaign_params[:status])
            end

           it 'assigns the created store campaign to the current user' do
               expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)
           end
        end

        context 'when the params are invalid' do
            let(:store_campaign_params) { attributes_for(:store_campaign, status: ' ') }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'does not save the store campaign in the database' do
                expect( StoreCampaign.find_by( status: store_campaign_params[:status] ) ).to be_nil 
            end

            # neste teste, ele especifica que quer especificamente o erro no titulo
            it 'returns the json errors for status' do
                expect(json_body[:errors]).to have_key(:status)
            end
        end
        
    end
    
    describe 'PUT /store_campaigns/:id' do
      let!(:store_campaign) { create(:store_campaign, user_id: user.id) }
      before do
          put "/store_campaigns/#{store_campaign.id}", params: { store_campaign: store_campaign_params }.to_json, headers: headers
      end
      
      context 'when the params are valid' do
          let(:store_campaign_params) { { status: 'A' } }

          it 'return status code 200' do
            expect(response).to have_http_status(200) 
          end

          it 'returns the json for updated store campaign' do
            expect(json_body[:data][:attributes][:status]).to eq(store_campaign_params[:status])
          end

          it 'updates the store campaign in the database' do 
            expect(StoreCampaign.find_by(status: store_campaign_params[:status])).not_to be_nil 
          end
      end
    
      context 'when the params are invalid' do
          let(:store_campaign_params) { { status: ' ' } }

          it 'return status code 422' do
            expect(response).to have_http_status(422) 
          end

          it 'returns the json error for status' do
            expect(json_body[:errors]).to have_key(:status)
          end

          it 'does not update the store campaign in the database' do
            expect( StoreCampaign.find_by(status: store_campaign_params[:status]) ).to be_nil
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