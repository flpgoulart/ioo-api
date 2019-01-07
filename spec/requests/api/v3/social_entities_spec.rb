require 'rails_helper'

# este comando serve para descrever o que o teste
RSpec.describe 'Social Entity API', type: :request do
    before { host! 'api.hopii.test' }
    
    let!(:user) { create(:user) }
    let!(:target_audience) { create(:target_audience) }
    let!(:occupation_area) { create(:occupation_area) }
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

    describe 'GET /social_entities' do

        context 'when no filter param is sent' do
        
            before do
                # é do FactoryGirl, serve para criar vários cadastros do mesmo objeto
                # neste caso, ele vai criar 5x, de acordo com o que foi parametrizado no factories/tasks
                create_list(:social_entity, 5, user_id: user.id)
                get '/social_entities', params: {}, headers: headers 
            end
            
            it 'returns status code 200' do
                expect(response).to have_http_status(200)  
            end

            it 'returns 5 social_entities from database' do
                expect(json_body[:data].count).to eq(5)
            end
        
        end 

        context 'when filter and sorting params is sent' do
            let!(:notebook_se_1) { create(:social_entity, name: 'Check if the notebook is broken', user_id: user.id ) }
            let!(:notebook_se_2) { create(:social_entity, name: 'Buy a new notebook', user_id: user.id ) }
            let!(:other_se_1)    { create(:social_entity, name: 'Fix the door', user_id: user.id ) }
            let!(:other_se_2)    { create(:social_entity, name: 'Buy a new car', user_id: user.id ) }

            before do
                get '/social_entities?q[name_cont]=note&q[s]=name+ASC', params: {}, headers: headers
            end
            
            it 'returns only the social_entities matching and in the correct order' do
                returned_se_names = json_body[:data].map { |t| t[:attributes][:name] } #map serve para navegar entre os itens do array

                expect(returned_se_names).to eq([notebook_se_2.name, notebook_se_1.name])  
            end

        end

    end
    
    describe 'GET /social_entities/:id' do
        let(:social_entity) {create(:social_entity, user_id: user.id)}

        before { get "/social_entities/#{social_entity.id}", params: {}, headers: headers }

        it 'returns status code 200' do
            expect(response).to have_http_status(200)
        end

        it 'returns the json for social_entities' do
            expect(json_body[:data][:attributes][:name]).to eq(social_entity.name)
        end
        
    end
    
    describe 'POST /social_entities' do
        before do
            post '/social_entities', params: { social_entity: social_entity_params }.to_json, headers: headers
        end
        
        context 'when the params are valid' do
            let(:occupation_area) { create(:occupation_area)}
            let(:target_audiences) { create(:target_audience)}
            let(:social_entity_params) { attributes_for(:social_entity, occupation_area_id: occupation_area.id, target_audience_id: target_audience.id) } 

            
            it 'save the social_entity in the database' do
                expect( SocialEntity.find_by( name: social_entity_params[:name] ) ).not_to be_nil 
            end

            it 'returns the json for created social_entity' do
                expect(json_body[:data][:attributes][:name]).to eq(social_entity_params[:name])
            end

            it 'assigns the created social_entity to the current user' do
                expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)
            end
        end

        context 'when the params are invalid' do
            let(:occupation_area) { create(:occupation_area)}
            let(:target_audiences) { create(:target_audience)}
            let(:social_entity_params) { attributes_for(:social_entity, name: ' ', occupation_area_id: occupation_area.id, target_audience_id: target_audience.id) }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'does not save the social_entity in the database' do
                expect( SocialEntity.find_by( name: social_entity_params[:name] ) ).to be_nil 
            end

            # neste teste, ele especifica que quer especificamente o erro no titulo
            it 'returns the json errors for name' do
                expect(json_body[:errors]).to have_key(:name)
            end
        end
        
        
    end
    
    describe 'PUT /social_entities/:id' do
      let!(:social_entity) { create(:social_entity, user_id: user.id ) }
      before do
          put "/social_entities/#{social_entity.id}", params: { social_entity: social_entity_params }.to_json, headers: headers
      end
      
      context 'when the params are valid' do
          let(:social_entity_params) { { name: 'New social entity name' } }

          it 'return status code 200' do
            expect(response).to have_http_status(200) 
          end

          it 'returns the json for updated social_entities' do
            expect(json_body[:data][:attributes][:name]).to eq(social_entity_params[:name])
          end

          it 'updates the social_entity in the database' do 
            expect(SocialEntity.find_by(name: social_entity_params[:name])).not_to be_nil 
          end
      end
    
      context 'when the params are invalid' do
          let(:social_entity_params) { { name: ' ' } }

          it 'return status code 422' do
            expect(response).to have_http_status(422) 
          end

          it 'returns the json error for name' do
            expect(json_body[:errors]).to have_key(:name)
          end

          it 'does not update the social_entity in the database' do
            expect( SocialEntity.find_by(name: social_entity_params[:name]) ).to be_nil
          end
      end
      
    end

    describe 'DELETE /social_entities/:id' do
      let!(:social_entity) { create(:social_entity, user_id: user.id) }

      before do
          delete "/social_entities/#{social_entity.id}", params: {}, headers: headers
      end
      
      it 'returns status code 204' do
          expect(response).to have_http_status(204)
      end

      it 'removes the social_entity from the database' do
          expect{ SocialEntity.find(social_entity.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
end