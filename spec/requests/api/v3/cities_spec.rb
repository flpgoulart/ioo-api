require 'rails_helper'

# este comando serve para descrever o que o teste
RSpec.describe 'Cities API', type: :request do
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

    describe 'GET /cities' do

        context 'when no filter param is sent' do
        
            before do
                # é do FactoryGirl, serve para criar vários cadastros do mesmo objeto
                # neste caso, ele vai criar 5x, de acordo com o que foi parametrizado no factories/tasks
                create_list(:city, 5)
                get '/cities', params: {}, headers: headers 
            end
            
            it 'returns status code 200' do
                expect(response).to have_http_status(200)  
            end

            it 'returns 5 cities from database' do
                expect(json_body[:data].count).to eq(5)
            end
        
        end 

        context 'when filter and sorting params is sent' do
            let!(:notebook_se_1) { create(:city, name: 'Check if the notebook is broken' ) }
            let!(:notebook_se_2) { create(:city, name: 'Buy a new notebook' ) }
            let!(:other_se_1)    { create(:city, name: 'Fix the door' ) }
            let!(:other_se_2)    { create(:city, name: 'Buy a new car' ) }

            before do
                get '/cities?q[name_cont]=note&q[s]=name+ASC', params: {}, headers: headers
            end
            
            it 'returns only the cities matching and in the correct order' do
                returned_se_names = json_body[:data].map { |t| t[:attributes][:name] } #map serve para navegar entre os itens do array

                expect(returned_se_names).to eq([notebook_se_2.name, notebook_se_1.name])  
            end

        end

    end
    
    describe 'GET /cities/:id' do
        let(:city) {create(:city)}

        before { get "/cities/#{city.id}", params: {}, headers: headers }

        it 'returns status code 200' do
            expect(response).to have_http_status(200)
        end

        it 'returns the json for cities' do
            expect(json_body[:data][:attributes][:name]).to eq(city.name)
        end
        
    end
    
    describe 'POST /cities' do
        before do
            post '/cities', params: { city: city_params }.to_json, headers: headers
        end
        
        context 'when the params are valid' do
            let(:city_params) { attributes_for(:city) } 

            it 'save the city in the database' do
                expect( City.find_by( name: city_params[:name] ) ).not_to be_nil 
            end

            it 'returns the json for created city' do
                expect(json_body[:data][:attributes][:name]).to eq(city_params[:name])
            end

#            it 'assigns the created social_entity to the current user' do
#                expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)
#            end
        end

        context 'when the params are invalid' do
            let(:city_params) { attributes_for(:city, name: ' ') }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'does not save the city in the database' do
                expect( City.find_by( name: city_params[:name] ) ).to be_nil 
            end

            # neste teste, ele especifica que quer especificamente o erro no titulo
            it 'returns the json errors for name' do
                expect(json_body[:errors]).to have_key(:name)
            end
        end
        
        
    end
    
    describe 'PUT /cities/:id' do
      let!(:city) { create(:city) }
      before do
          put "/cities/#{city.id}", params: { city: city_params }.to_json, headers: headers
      end
      
      context 'when the params are valid' do
          let(:city_params) { { name: 'New city name' } }

          it 'return status code 200' do
            expect(response).to have_http_status(200) 
          end

          it 'returns the json for updated cities' do
            expect(json_body[:data][:attributes][:name]).to eq(city_params[:name])
          end

          it 'updates the city in the database' do 
            expect(City.find_by(name: city_params[:name])).not_to be_nil 
          end
      end
    
      context 'when the params are invalid' do
          let(:city_params) { { name: ' ' } }

          it 'return status code 422' do
            expect(response).to have_http_status(422) 
          end

          it 'returns the json error for name' do
            expect(json_body[:errors]).to have_key(:name)
          end

          it 'does not update the city in the database' do
            expect( City.find_by(name: city_params[:name]) ).to be_nil
          end
      end
      
    end

    describe 'DELETE /cities/:id' do
      let!(:city) { create(:city) }

      before do
          delete "/cities/#{city.id}", params: {}, headers: headers
      end
      
      it 'returns status code 204' do
          expect(response).to have_http_status(204)
      end

      it 'removes the city from the database' do
          expect{ City.find(city.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
end