require 'rails_helper'

# este comando serve para descrever o que o teste
RSpec.describe 'Occupation Area API', type: :request do
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

    describe 'GET /occupation_areas' do

        context 'when no filter param is sent' do
        
            before do
                # é do FactoryGirl, serve para criar vários cadastros do mesmo objeto
                # neste caso, ele vai criar 5x, de acordo com o que foi parametrizado no factories/tasks
                create_list(:occupation_area, 5)
                get '/occupation_areas', params: {}, headers: headers 
            end
            
            it 'returns status code 200' do
                expect(response).to have_http_status(200)  
            end

            it 'returns 5 occupation_area from database' do
                expect(json_body[:data].count).to eq(5)
            end
        
        end 

        context 'when filter and sorting params is sent' do
            let!(:notebook_task_1) { create(:occupation_area, name: 'Check if the notebook is broken' ) }
            let!(:notebook_task_2) { create(:occupation_area, name: 'Buy a new notebook' ) }
            let!(:other_task_1)    { create(:occupation_area, name: 'Fix the door' ) }
            let!(:other_task_2)    { create(:occupation_area, name: 'Buy a new car' ) }

            before do
                get '/occupation_areas?q[name_cont]=note&q[s]=name+ASC', params: {}, headers: headers
            end
            
            it 'returns only the occupation_areas matching and in the correct order' do
                returned_oa_names = json_body[:data].map { |t| t[:attributes][:name] } 

                expect(returned_oa_names).to eq([notebook_task_2.name, notebook_task_1.name])  
            end
            
        end
        
    end
    
    describe 'GET /occupation_areas/:id' do
        let(:occupation_area) {create(:occupation_area)}

        before { get "/occupation_areas/#{occupation_area.id}", params: {}, headers: headers }

        it 'returns status code 200' do
            expect(response).to have_http_status(200)
        end

        it 'returns the json for occupation_areas' do
            expect(json_body[:data][:attributes][:name]).to eq(occupation_area.name)
        end
        
    end
    
    describe 'POST /occupation_areas' do
        before do
            post '/occupation_areas', params: { occupation_area: occupation_area_params }.to_json, headers: headers
        end
        
        context 'when the params are valid' do
            let(:occupation_area_params) { attributes_for(:occupation_area) } 

            it 'returns status code 201' do
                expect(response).to have_http_status(201)
            end
            
            it 'save the occupation_area in the database' do
                expect( OccupationArea.find_by( name: occupation_area_params[:name] ) ).not_to be_nil 
            end

            it 'returns the json for created occupation_area' do
                expect(json_body[:data][:attributes][:name]).to eq(occupation_area_params[:name])
            end

        end

        context 'when the params are invalid' do
            let(:occupation_area_params) { attributes_for(:occupation_area, name: ' ') }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'does not save the occupation_area in the database' do
                expect( OccupationArea.find_by( name: occupation_area_params[:name] ) ).to be_nil 
            end

            # neste teste, ele especifica que quer especificamente o erro no titulo
            it 'returns the json errors for name' do
                expect(json_body[:errors]).to have_key(:name)
            end
        end
        
        
    end
    
    describe 'PUT /occupation_areas/:id' do
      let!(:occupation_area) { create(:occupation_area) }
      before do
          put "/occupation_areas/#{occupation_area.id}", params: { occupation_area: occupation_area_params }.to_json, headers: headers
      end
      
      context 'when the params are valid' do
          let(:occupation_area_params) { { name: 'New occupation_area name' } }

          it 'return status code 200' do
            expect(response).to have_http_status(200) 
          end

          it 'returns the json for updated occupation_areas' do
            expect(json_body[:data][:attributes][:name]).to eq(occupation_area_params[:name])
          end

          it 'updates the occupation_area in the database' do 
            expect(OccupationArea.find_by(name: occupation_area_params[:name])).not_to be_nil 
          end
      end
    
      context 'when the params are invalid' do
          let(:occupation_area_params) { { name: ' ' } }

          it 'return status code 422' do
            expect(response).to have_http_status(422) 
          end

          it 'returns the json error for name' do
            expect(json_body[:errors]).to have_key(:name)
          end

          it 'does not update the occupation_area in the database' do
            expect( OccupationArea.find_by(name: occupation_area_params[:name]) ).to be_nil
          end
      end
      
    end

    describe 'DELETE /occupation_areas/:id' do
      let!(:occupation_area) { create(:occupation_area) }

      before do
          delete "/occupation_areas/#{occupation_area.id}", params: {}, headers: headers
      end
      
      it 'returns status code 204' do
          expect(response).to have_http_status(204)
      end

      it 'removes the occupation_area from the database' do
          expect{ OccupationArea.find(occupation_area.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
end