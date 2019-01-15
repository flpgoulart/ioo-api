require 'rails_helper'

# este comando serve para descrever o que o teste
RSpec.describe 'Unit Measure API', type: :request do
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

    describe 'GET /unit_measures' do

        context 'when no filter param is sent' do
        
            before do
                # é do FactoryGirl, serve para criar vários cadastros do mesmo objeto
                # neste caso, ele vai criar 5x, de acordo com o que foi parametrizado no factories/tasks
                create_list(:unit_measure, 5)
                get '/unit_measures', params: {}, headers: headers 
            end
            
            it 'returns status code 200' do
                expect(response).to have_http_status(200)  
            end

            it 'returns 5 unit measures from database' do
                expect(json_body[:data].count).to eq(5)
            end
        
        end 

        context 'when filter and sorting params is sent' do
            let!(:notebook_se_1) { create(:unit_measure, name: 'Check if the notebook is broken' ) }
            let!(:notebook_se_2) { create(:unit_measure, name: 'Buy a new notebook' ) }
            let!(:other_se_1)    { create(:unit_measure, name: 'Fix the door' ) }
            let!(:other_se_2)    { create(:unit_measure, name: 'Buy a new car' ) }

            before do
                get '/unit_measures?q[name_cont]=note&q[s]=name+ASC', params: {}, headers: headers
            end
            
            it 'returns only the unit measures matching and in the correct order' do
                returned_se_names = json_body[:data].map { |t| t[:attributes][:name] } #map serve para navegar entre os itens do array

                expect(returned_se_names).to eq([notebook_se_2.name, notebook_se_1.name])  
            end

        end

    end
    
    describe 'GET /unit_measures/:id' do
        let(:unit_measure) {create(:unit_measure)}

        before { get "/unit_measures/#{unit_measure.id}", params: {}, headers: headers }

        it 'returns status code 200' do
            expect(response).to have_http_status(200)
        end

        it 'returns the json for unit measures' do
            expect(json_body[:data][:attributes][:name]).to eq(unit_measure.name)
        end
        
    end
    
    describe 'POST /unit_measures' do
        before do
            post '/unit_measures', params: { unit_measure: unit_measure_params }.to_json, headers: headers
        end
        
        context 'when the params are valid' do
            let(:unit_measure_params) { attributes_for(:unit_measure) } 

            it 'save the unit measures in the database' do
                expect( UnitMeasure.find_by( name: unit_measure_params[:name] ) ).not_to be_nil 
            end

            it 'returns the json for created unit measure' do
                expect(json_body[:data][:attributes][:name]).to eq(unit_measure_params[:name])
            end

#            it 'assigns the created social_entity to the current user' do
#                expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)
#            end
        end

        context 'when the params are invalid' do
            let(:unit_measure_params) { attributes_for(:unit_measure, name: ' ') }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'does not save the unit measure in the database' do
                expect( UnitMeasure.find_by( name: unit_measure_params[:name] ) ).to be_nil 
            end

            # neste teste, ele especifica que quer especificamente o erro no titulo
            it 'returns the json errors for name' do
                expect(json_body[:errors]).to have_key(:name)
            end
        end
        
        
    end
    
    describe 'PUT /unit_measures/:id' do
      let!(:unit_measure) { create(:unit_measure) }
      before do
          put "/unit_measures/#{unit_measure.id}", params: { unit_measure: unit_measure_params }.to_json, headers: headers
      end
      
      context 'when the params are valid' do
          let(:unit_measure_params) { { name: 'New unit measure name' } }

          it 'return status code 200' do
            expect(response).to have_http_status(200) 
          end

          it 'returns the json for updated unit measures' do
            expect(json_body[:data][:attributes][:name]).to eq(unit_measure_params[:name])
          end

          it 'updates the unit measure in the database' do 
            expect(UnitMeasure.find_by(name: unit_measure_params[:name])).not_to be_nil 
          end
      end
    
      context 'when the params are invalid' do
          let(:unit_measure_params) { { name: ' ' } }

          it 'return status code 422' do
            expect(response).to have_http_status(422) 
          end

          it 'returns the json error for name' do
            expect(json_body[:errors]).to have_key(:name)
          end

          it 'does not update the unit measure in the database' do
            expect( UnitMeasure.find_by(name: unit_measure_params[:name]) ).to be_nil
          end
      end
      
    end

    describe 'DELETE /unit_measures/:id' do
      let!(:unit_measure) { create(:unit_measure) }

      before do
          delete "/unit_measures/#{unit_measure.id}", params: {}, headers: headers
      end
      
      it 'returns status code 204' do
          expect(response).to have_http_status(204)
      end

      it 'removes the unit measure from the database' do
          expect{ UnitMeasure.find(unit_measure.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

end