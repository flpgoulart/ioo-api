require 'rails_helper'

# este comando serve para descrever o que o teste
RSpec.describe 'BusinessAccounts API', type: :request do
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

    describe 'GET /business_accounts' do

        context 'when no filter param is sent' do
        
            before do
                # é do FactoryGirl, serve para criar vários cadastros do mesmo objeto
                # neste caso, ele vai criar 5x, de acordo com o que foi parametrizado no factories/tasks
                create_list(:business_account, 5, user_id: user.id)
                get '/business_accounts', params: {}, headers: headers 
            end
            
            it 'returns status code 200' do
                expect(response).to have_http_status(200)  
            end

            it 'returns 5 businesses from database' do
                expect(json_body[:data].count).to eq(5)
            end
        
        end 

        context 'when filter and sorting params is sent' do
            let!(:notebook_se_1) { create(:business_account, name: 'Check if the notebook is broken', user_id: user.id ) }
            let!(:notebook_se_2) { create(:business_account, name: 'Buy a new notebook', user_id: user.id ) }
            let!(:other_se_1)    { create(:business_account, name: 'Fix the door', user_id: user.id ) }
            let!(:other_se_2)    { create(:business_account, name: 'Buy a new car', user_id: user.id ) }

            before do
                get '/business_accounts?q[name_cont]=note&q[s]=name+ASC', params: {}, headers: headers
            end
            
            it 'returns only the business accounts matching and in the correct order' do
                returned_se_names = json_body[:data].map { |t| t[:attributes][:name] } #map serve para navegar entre os itens do array

                expect(returned_se_names).to eq([notebook_se_2.name, notebook_se_1.name])  
            end

        end

    end
    
    describe 'GET /business_accounts/:id' do
        let(:business_account) {create(:business_account, user_id: user.id)}

        before { get "/business_accounts/#{business_account.id}", params: {}, headers: headers }

        it 'returns status code 200' do
            expect(response).to have_http_status(200)
        end

        it 'returns the json for business account' do
            expect(json_body[:data][:attributes][:name]).to eq(business_account.name)
        end
        
    end
    
    describe 'POST /business_accounts' do
        before do
            post '/business_accounts', params: { business_account: business_account_params }.to_json, headers: headers
        end
        
        context 'when the params are valid' do
            let(:business_account_params) { attributes_for(:business_account) } 

            it 'save the business account in the database' do
                expect( BusinessAccount.find_by( name: business_account_params[:name] ) ).not_to be_nil 
            end

            it 'returns the json for created business account' do
                expect(json_body[:data][:attributes][:name]).to eq(business_account_params[:name])
            end

           it 'assigns the created business account to the current user' do
               expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)
           end
        end

        context 'when the params are invalid' do
            let(:business_account_params) { attributes_for(:business_account, name: ' ') }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'does not save the business account in the database' do
                expect( BusinessAccount.find_by( name: business_account_params[:name] ) ).to be_nil 
            end

            # neste teste, ele especifica que quer especificamente o erro no titulo
            it 'returns the json errors for name' do
                expect(json_body[:errors]).to have_key(:name)
            end
        end
        
    end
    
    describe 'PUT /business_accounts/:id' do
      let!(:business_account) { create(:business_account, user_id: user.id) }
      before do
          put "/business_accounts/#{business_account.id}", params: { business_account: business_account_params }.to_json, headers: headers
      end
      
      context 'when the params are valid' do
          let(:business_account_params) { { name: 'New business name' } }

          it 'return status code 200' do
            expect(response).to have_http_status(200) 
          end

          it 'returns the json for updated business account' do
            expect(json_body[:data][:attributes][:name]).to eq(business_account_params[:name])
          end

          it 'updates the business account in the database' do 
            expect(BusinessAccount.find_by(name: business_account_params[:name])).not_to be_nil 
          end
      end
    
      context 'when the params are invalid' do
          let(:business_account_params) { { name: ' ' } }

          it 'return status code 422' do
            expect(response).to have_http_status(422) 
          end

          it 'returns the json error for name' do
            expect(json_body[:errors]).to have_key(:name)
          end

          it 'does not update the business account in the database' do
            expect( BusinessAccount.find_by(name: business_account_params[:name]) ).to be_nil
          end
      end
      
    end

#     describe 'DELETE /businesses/:id' do
#       let!(:business) { create(:business) }

#       before do
#           delete "/businesses/#{business.id}", params: {}, headers: headers
#       end
      
#       it 'returns status code 204' do
#           expect(response).to have_http_status(204)
#       end

#       it 'removes the business from the database' do
#           expect{ StoreType.find(business.id) }.to raise_error(ActiveRecord::RecordNotFound)
#       end
#     end
end