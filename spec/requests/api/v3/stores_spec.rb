require 'rails_helper'

# este comando serve para descrever o que o teste
RSpec.describe 'Stores API', type: :request do
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

    describe 'GET /stores' do

        context 'when no filter param is sent' do
        
            before do
                # é do FactoryGirl, serve para criar vários cadastros do mesmo objeto
                # neste caso, ele vai criar 5x, de acordo com o que foi parametrizado no factories/tasks
                create_list(:store, 5, user_id: user.id)
                get '/stores', params: {}, headers: headers 
            end
            
            it 'returns status code 200' do
                expect(response).to have_http_status(200)  
            end

            it 'returns 5 stores from database' do
                expect(json_body[:data].count).to eq(5)
            end
        
        end 

        context 'when filter and sorting params is sent' do
            let!(:notebook_se_1) { create(:store, name: 'Check if the notebook is broken', user_id: user.id ) }
            let!(:notebook_se_2) { create(:store, name: 'Buy a new notebook', user_id: user.id ) }
            let!(:other_se_1)    { create(:store, name: 'Fix the door', user_id: user.id ) }
            let!(:other_se_2)    { create(:store, name: 'Buy a new car', user_id: user.id ) }

            before do
                get '/stores?q[name_cont]=note&q[s]=name+ASC', params: {}, headers: headers
            end
            
            it 'returns only the stores matching and in the correct order' do
                returned_se_names = json_body[:data].map { |t| t[:attributes][:name] } #map serve para navegar entre os itens do array

                expect(returned_se_names).to eq([notebook_se_2.name, notebook_se_1.name])  
            end

        end

    end
    
    describe 'GET /stores/:id' do
        let(:store) {create(:store, user_id: user.id)}

        before { get "/stores/#{store.id}", params: {}, headers: headers }

        it 'returns status code 200' do
            expect(response).to have_http_status(200)
        end

        it 'returns the json for store' do
            expect(json_body[:data][:attributes][:name]).to eq(store.name)
        end
        
    end
    
    describe 'POST /stores' do
        before do
            post '/stores', params: { store: store_params }.to_json, headers: headers
        end
        
        context 'when the params are valid' do

            let(:store_type) { create(:store_type)}
            let(:business) { create(:business)}
            let(:city) { create(:city)}

            let(:store_params) { attributes_for(:store, store_type_id: store_type.id, business_id: business.id, city_id: city.id, user_id: user.id ) } 

            it 'save the store in the database' do
                expect( Store.find_by( name: store_params[:name] ) ).not_to be_nil 
            end

            it 'returns the json for created store' do
                expect(json_body[:data][:attributes][:name]).to eq(store_params[:name])
            end

           it 'assigns the created store to the current user' do
               expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)
           end
        end

        context 'when the params are invalid' do
            let(:store_params) { attributes_for(:store, name: ' ') }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'does not save the store in the database' do
                expect( Store.find_by( name: store_params[:name] ) ).to be_nil 
            end

            # neste teste, ele especifica que quer especificamente o erro no titulo
            it 'returns the json errors for name' do
                expect(json_body[:errors]).to have_key(:name)
            end
        end
        
    end
    
    describe 'PUT /stores/:id' do
      let!(:store) { create(:store, user_id: user.id) }
      before do
          put "/stores/#{store.id}", params: { store: store_params }.to_json, headers: headers
      end
      
      context 'when the params are valid' do
          let(:store_params) { { name: 'New store name' } }

          it 'return status code 200' do
            expect(response).to have_http_status(200) 
          end

          it 'returns the json for updated store' do
            expect(json_body[:data][:attributes][:name]).to eq(store_params[:name])
          end

          it 'updates the store in the database' do 
            expect(Store.find_by(name: store_params[:name])).not_to be_nil 
          end
      end
    
      context 'when the params are invalid' do
          let(:store_params) { { name: ' ' } }

          it 'return status code 422' do
            expect(response).to have_http_status(422) 
          end

          it 'returns the json error for name' do
            expect(json_body[:errors]).to have_key(:name)
          end

          it 'does not update the store in the database' do
            expect( Store.find_by(name: store_params[:name]) ).to be_nil
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