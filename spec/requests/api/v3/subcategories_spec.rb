require 'rails_helper'

# este comando serve para descrever o que o teste
RSpec.describe 'Subcategories API', type: :request do
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

    describe 'GET /subcategories' do

        context 'when no filter param is sent' do
        
            before do
                # é do FactoryGirl, serve para criar vários cadastros do mesmo objeto
                # neste caso, ele vai criar 5x, de acordo com o que foi parametrizado no factories/tasks
                create_list(:subcategory, 5)
                get '/subcategories', params: {}, headers: headers 
            end
            
            it 'returns status code 200' do
                expect(response).to have_http_status(200)  
            end

            it 'returns 5 subcategories from database' do
                expect(json_body[:data].count).to eq(5)
            end
        
        end 

        context 'when filter and sorting params is sent' do
            let!(:notebook_se_1) { create(:subcategory, name: 'Check if the notebook is broken' ) }
            let!(:notebook_se_2) { create(:subcategory, name: 'Buy a new notebook' ) }
            let!(:other_se_1)    { create(:subcategory, name: 'Fix the door' ) }
            let!(:other_se_2)    { create(:subcategory, name: 'Buy a new car' ) }

            before do
                get '/subcategories?q[name_cont]=note&q[s]=name+ASC', params: {}, headers: headers
            end
            
            it 'returns only the subcategories matching and in the correct order' do
                returned_se_names = json_body[:data].map { |t| t[:attributes][:name] } #map serve para navegar entre os itens do array

                expect(returned_se_names).to eq([notebook_se_2.name, notebook_se_1.name])  
            end

        end

    end
    
    describe 'GET /subcategories/:id' do
        let(:subcategory) {create(:subcategory)}

        before { get "/subcategories/#{subcategory.id}", params: {}, headers: headers }

        it 'returns status code 200' do
            expect(response).to have_http_status(200)
        end

        it 'returns the json for subcategories' do
            expect(json_body[:data][:attributes][:name]).to eq(subcategory.name)
        end
        
    end
    
    describe 'POST /subcategories' do
        before do
            post '/subcategories', params: { subcategory: subcategory_params }.to_json, headers: headers
        end
        
        context 'when the params are valid' do
            let(:category) { create(:category)}
            let(:subcategory_params) { attributes_for(:subcategory, category_id: category.id ) } 

            it 'save the subcategory in the database' do
                expect( Subcategory.find_by( name: subcategory_params[:name] ) ).not_to be_nil 
            end

            it 'returns the json for created subcategory' do
                expect(json_body[:data][:attributes][:name]).to eq(subcategory_params[:name])
            end

#            it 'assigns the created social_entity to the current user' do
#                expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)
#            end
        end

        context 'when the params are invalid' do
            let(:category) { create(:category)}
            let(:subcategory_params) { attributes_for(:subcategory, name: ' ', category_id: category.id) }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'does not save the subcategory in the database' do
                expect( Subcategory.find_by( name: subcategory_params[:name] ) ).to be_nil 
            end

            # neste teste, ele especifica que quer especificamente o erro no titulo
            it 'returns the json errors for name' do
                expect(json_body[:errors]).to have_key(:name)
            end
        end
    end
    
    describe 'PUT /subcategories/:id' do
      let!(:subcategory) { create(:subcategory) }
      before do
          put "/subcategories/#{subcategory.id}", params: { subcategory: subcategory_params }.to_json, headers: headers
      end
      
      context 'when the params are valid' do
          let(:subcategory_params) { { name: 'New subcategory name' } }

          it 'return status code 200' do
            expect(response).to have_http_status(200) 
          end

          it 'returns the json for updated subcategories' do
            expect(json_body[:data][:attributes][:name]).to eq(subcategory_params[:name])
          end

          it 'updates the subcategory in the database' do 
            expect(Subcategory.find_by(name: subcategory_params[:name])).not_to be_nil 
          end
      end
    
      context 'when the params are invalid' do
          let(:subcategory_params) { { name: ' ' } }

          it 'return status code 422' do
            expect(response).to have_http_status(422) 
          end

          it 'returns the json error for name' do
            expect(json_body[:errors]).to have_key(:name)
          end

          it 'does not update the category in the database' do
            expect( Subcategory.find_by(name: subcategory_params[:name]) ).to be_nil
          end
      end
      
    end

    describe 'DELETE /subcategories/:id' do
      let!(:subcategory) { create(:subcategory) }

      before do
          delete "/subcategories/#{subcategory.id}", params: {}, headers: headers
      end
      
      it 'returns status code 204' do
          expect(response).to have_http_status(204)
      end

      it 'removes the subcategory from the database' do
          expect{ Subcategory.find(subcategory.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
end