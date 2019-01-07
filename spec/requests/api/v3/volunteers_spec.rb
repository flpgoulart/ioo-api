require 'rails_helper'

# este comando serve para descrever o que o teste
RSpec.describe 'Volunteer API', type: :request do
    before { host! 'api.hopii.test' }
    
    let!(:user) { create(:user) }
    let!(:auth_data) { user.create_new_auth_token }
    let(:headers) do 
        {
            'Accept' => 'application/vnd.hopii.v3',
            'Content-Type' => Mime[:json].to_s,
            'Authorization' => user.auth_token,
            'access-token' => auth_data['access-token'],
            'uid' => auth_data['uid'],
            'client' => auth_data['client']
        }
    end

    describe 'GET /volunteers' do

        context 'when no filter param is sent' do
        
            before do
                # é do FactoryGirl, serve para criar vários cadastros do mesmo objeto
                # neste caso, ele vai criar 5x, de acordo com o que foi parametrizado no factories/tasks
                create_list(:volunteer, 5, user_id: user.id)
                get '/volunteers', params: {}, headers: headers 
            end
            
            it 'returns status code 200' do
                expect(response).to have_http_status(200)  
            end

            it 'returns 5 volunteers from database' do
                expect(json_body[:data].count).to eq(5)
            end
        
        end 

        context 'when filter and sorting params is sent' do
            let!(:notebook_se_1) { create(:volunteer, name: 'Check if the notebook is broken', user_id: user.id ) }
            let!(:notebook_se_2) { create(:volunteer, name: 'Buy a new notebook', user_id: user.id ) }
            let!(:other_se_1)    { create(:volunteer, name: 'Fix the door', user_id: user.id ) }
            let!(:other_se_2)    { create(:volunteer, name: 'Buy a new car', user_id: user.id ) }

            before do
                get '/volunteers?q[name_cont]=note&q[s]=name+ASC', params: {}, headers: headers
            end
            
            it 'returns only the volunteers matching and in the correct order' do
                returned_se_names = json_body[:data].map { |t| t[:attributes][:name] } #map serve para navegar entre os itens do array

                expect(returned_se_names).to eq([notebook_se_2.name, notebook_se_1.name])  
            end

        end

    end
    
    describe 'GET /volunteers/:id' do
        let(:volunteer) {create(:volunteer, user_id: user.id)}

        before { get "/volunteers/#{volunteer.id}", params: {}, headers: headers }

        it 'returns status code 200' do
            expect(response).to have_http_status(200)
        end

        it 'returns the json for volunteers' do
            expect(json_body[:data][:attributes][:name]).to eq(volunteer.name)
        end
        
    end
    
    describe 'POST /volunteers' do
        before do
            post '/volunteers', params: { volunteer: volunteer_params }.to_json, headers: headers
        end
        
        context 'when the params are valid' do
            let(:volunteer_params) { attributes_for(:volunteer) } 

            
            it 'save the volunteer in the database' do
                expect( Volunteer.find_by( name: volunteer_params[:name] ) ).not_to be_nil 
            end

            it 'returns the json for created volunteer' do
                expect(json_body[:data][:attributes][:name]).to eq(volunteer_params[:name])
            end

            it 'assigns the created volunteer to the current user' do
                expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)
            end
        end

        context 'when the params are invalid' do
            let(:volunteer_params) { attributes_for(:volunteer, name: ' ') }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'does not save the volunteer in the database' do
                expect( Volunteer.find_by( name: volunteer_params[:name] ) ).to be_nil 
            end

            # neste teste, ele especifica que quer especificamente o erro no titulo
            it 'returns the json errors for name' do
                expect(json_body[:errors]).to have_key(:name)
            end
        end
        
        
    end
    
    describe 'PUT /volunteers/:id' do
      let!(:volunteer) { create(:volunteer, user_id: user.id ) }
      before do
          put "/volunteers/#{volunteer.id}", params: { volunteer: volunteer_params }.to_json, headers: headers
      end
      
      context 'when the params are valid' do
          let(:volunteer_params) { { name: 'New volunteer name' } }

          it 'return status code 200' do
            expect(response).to have_http_status(200) 
          end

          it 'returns the json for updated volunteer' do
            expect(json_body[:data][:attributes][:name]).to eq(volunteer_params[:name])
          end

          it 'updates the volunteer in the database' do 
            expect(Volunteer.find_by(name: volunteer_params[:name])).not_to be_nil 
          end
      end
    
      context 'when the params are invalid' do
          let(:volunteer_params) { { name: ' ' } }

          it 'return status code 422' do
            expect(response).to have_http_status(422) 
          end

          it 'returns the json error for name' do
            expect(json_body[:errors]).to have_key(:name)
          end

          it 'does not update the volunteer in the database' do
            expect( Volunteer.find_by(name: volunteer_params[:name]) ).to be_nil
          end
      end
      
    end

    describe 'DELETE /volunteers/:id' do
      let!(:volunteer) { create(:volunteer, user_id: user.id) }

      before do
          delete "/volunteers/#{volunteer.id}", params: {}, headers: headers
      end
      
      it 'returns status code 204' do
          expect(response).to have_http_status(204)
      end

      it 'removes the volunteer from the database' do
          expect{ Volunteer.find(volunteer.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
end