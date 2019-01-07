require 'rails_helper'

# este comando serve para descrever o que o teste
RSpec.describe 'Improvement API', type: :request do
    before { host! 'api.hopii.test' }
    
    let!(:user) { create(:user) }
    let!(:social_entity) { create(:social_entity, user_id: user.id ) }
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

    describe 'GET /improvements' do

        context 'when no filter param is sent' do
        
            before do
                # é do FactoryGirl, serve para criar vários cadastros do mesmo objeto
                # neste caso, ele vai criar 5x, de acordo com o que foi parametrizado no factories/tasks
                create_list(:improvement, 5, social_entity_id: social_entity.id)
                get '/improvements', params: {}, headers: headers 
            end
            
            it 'returns status code 200' do
                expect(response).to have_http_status(200)  
            end

            it 'returns 5 improvement from database' do
                expect(json_body[:data].count).to eq(5)
            end
        
        end 

        context 'when filter and sorting params is sent' do
            let!(:notebook_se_1) { create(:improvement, title: 'Check if the notebook is broken', social_entity_id: social_entity.id ) }
            let!(:notebook_se_2) { create(:improvement, title: 'Buy a new notebook', social_entity_id: social_entity.id ) }
            let!(:other_se_1)    { create(:improvement, title: 'Fix the door', social_entity_id: social_entity.id ) }
            let!(:other_se_2)    { create(:improvement, title: 'Buy a new car', social_entity_id: social_entity.id ) }

            before do
                get '/improvements?q[title_cont]=note&q[s]=title+ASC', params: {}, headers: headers
            end
            
            it 'returns only the improvement matching and in the correct order' do
                returned_se_names = json_body[:data].map { |t| t[:attributes][:title] } #map serve para navegar entre os itens do array

                expect(returned_se_names).to eq([notebook_se_2.title, notebook_se_1.title])  
            end

        end

    end

    describe 'GET /improvements/:id' do
        let(:improvement) {create(:improvement, social_entity_id: social_entity.id)}

        before { get "/improvements/#{improvement.id}", params: {}, headers: headers }

        it 'returns status code 200' do
            expect(response).to have_http_status(200)
        end

        it 'returns the json for improvements' do
            expect(json_body[:data][:attributes][:title]).to eq(improvement.title)
        end
        
    end
    
    describe 'POST /improvements' do
        before do
            post '/improvements', params: { improvement: improvement_params }.to_json, headers: headers
        end
        
        context 'when the params are valid' do
            let(:improvement_params) { attributes_for(:improvement, social_entity_id: social_entity.id) } 

            
            it 'save the improvement in the database' do
                expect( Improvement.find_by( title: improvement_params[:title] ) ).not_to be_nil 
            end

            it 'returns the json for created improvement' do
                expect(json_body[:data][:attributes][:title]).to eq(improvement_params[:title])
            end

            it 'assigns the created improvement to the current social entity' do
                expect(json_body[:data][:attributes][:'social-entity-id']).to eq(social_entity.id)
            end
        end

        context 'when the params are invalid' do
            let(:improvement_params) { attributes_for(:improvement, title: ' ', social_entity_id: social_entity.id) }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'does not save the improvement in the database' do
                expect( Improvement.find_by( title: improvement_params[:title] ) ).to be_nil 
            end

            # neste teste, ele especifica que quer especificamente o erro no titulo
            it 'returns the json errors for title' do
                expect(json_body[:errors]).to have_key(:title)
            end
        end
        
    end
    
    describe 'PUT /improvements/:id' do
      let!(:improvement) { create(:improvement, social_entity_id: social_entity.id ) }
      before do
          put "/improvements/#{improvement.id}", params: { improvement: improvement_params }.to_json, headers: headers
      end
      
      context 'when the params are valid' do
          let(:improvement_params) { { title: 'New improvement title' } }

          it 'return status code 200' do
            expect(response).to have_http_status(200) 
          end

          it 'returns the json for updated improvement' do
            expect(json_body[:data][:attributes][:title]).to eq(improvement_params[:title])
          end

          it 'updates the improvement in the database' do 
            expect(Improvement.find_by(title: improvement_params[:title])).not_to be_nil 
          end
      end
    
      context 'when the params are invalid' do
          let(:improvement_params) { { title: ' ' } }

          it 'return status code 422' do
            expect(response).to have_http_status(422) 
          end

          it 'returns the json error for title' do
            expect(json_body[:errors]).to have_key(:title)
          end

          it 'does not update the improvement in the database' do
            expect( Improvement.find_by(title: improvement_params[:title]) ).to be_nil
          end
      end
      
    end

    describe 'DELETE /improvements/:id' do
      let!(:improvement) { create(:improvement, social_entity_id: social_entity.id) }

      before do
          delete "/improvements/#{improvement.id}", params: {}, headers: headers
      end
      
      it 'returns status code 204' do
          expect(response).to have_http_status(204)
      end

      it 'removes the improvement from the database' do
          expect{ Improvement.find(improvement.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
end