require 'rails_helper'

# este comando serve para descrever o que o teste
RSpec.describe 'Target Audience API', type: :request do
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

    describe 'GET /target_audiences' do

        context 'when no filter param is sent' do
        
            before do
                # é do FactoryGirl, serve para criar vários cadastros do mesmo objeto
                # neste caso, ele vai criar 5x, de acordo com o que foi parametrizado no factories/tasks
                create_list(:target_audience, 5)
                get '/target_audiences', params: {}, headers: headers 
            end
            
            it 'returns status code 200' do
                expect(response).to have_http_status(200)  
            end

            it 'returns 5 target_audience from database' do
                expect(json_body[:data].count).to eq(5)
            end
        
        end 

        context 'when filter and sorting params is sent' do
            let!(:notebook_task_1) { create(:target_audience, name: 'Check if the notebook is broken' ) }
            let!(:notebook_task_2) { create(:target_audience, name: 'Buy a new notebook' ) }
            let!(:other_task_1)    { create(:target_audience, name: 'Fix the door' ) }
            let!(:other_task_2)    { create(:target_audience, name: 'Buy a new car' ) }

            before do
                get '/target_audiences?q[name_cont]=note&q[s]=name+ASC', params: {}, headers: headers
            end
            
            it 'returns only the target_audiences matching and in the correct order' do
                returned_ta_names = json_body[:data].map { |t| t[:attributes][:name] } 

                expect(returned_ta_names).to eq([notebook_task_2.name, notebook_task_1.name])  
            end
            

        end
        

    end
    
    describe 'GET /target_audiences/:id' do
        let(:target_audience) {create(:target_audience)}

        before { get "/target_audiences/#{target_audience.id}", params: {}, headers: headers }

        it 'returns status code 200' do
            expect(response).to have_http_status(200)
        end

        it 'returns the json for target_audiences' do
            expect(json_body[:data][:attributes][:name]).to eq(target_audience.name)
        end
        
    end
    
    describe 'POST /target_audiences' do
        before do
            post '/target_audiences', params: { target_audience: target_audience_params }.to_json, headers: headers
        end
        
        context 'when the params are valid' do
            let(:target_audience_params) { attributes_for(:target_audience) } 

            it 'returns status code 201' do
                expect(response).to have_http_status(201)
            end
            
            it 'save the target_audience in the database' do
                expect( TargetAudience.find_by( name: target_audience_params[:name] ) ).not_to be_nil 
            end

            it 'returns the json for created target_audience' do
                expect(json_body[:data][:attributes][:name]).to eq(target_audience_params[:name])
            end

        end

        context 'when the params are invalid' do
            let(:target_audience_params) { attributes_for(:target_audience, name: ' ') }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'does not save the target_audience in the database' do
                expect( TargetAudience.find_by( name: target_audience_params[:name] ) ).to be_nil 
            end

            # neste teste, ele especifica que quer especificamente o erro no titulo
            it 'returns the json errors for name' do
                expect(json_body[:errors]).to have_key(:name)
            end
        end
        
        
    end
    
    describe 'PUT /target_audiences/:id' do
      let!(:target_audience) { create(:target_audience) }
      before do
          put "/target_audiences/#{target_audience.id}", params: { target_audience: target_audience_params }.to_json, headers: headers
      end
      
      context 'when the params are valid' do
          let(:target_audience_params) { { name: 'New target_audience name' } }

          it 'return status code 200' do
            expect(response).to have_http_status(200) 
          end

          it 'returns the json for updated target_audiences' do
            expect(json_body[:data][:attributes][:name]).to eq(target_audience_params[:name])
          end

          it 'updates the target_audience in the database' do 
            expect(TargetAudience.find_by(name: target_audience_params[:name])).not_to be_nil 
          end
      end
    
      context 'when the params are invalid' do
          let(:target_audience_params) { { name: ' ' } }

          it 'return status code 422' do
            expect(response).to have_http_status(422) 
          end

          it 'returns the json error for name' do
            expect(json_body[:errors]).to have_key(:name)
          end

          it 'does not update the target_audience in the database' do
            expect( TargetAudience.find_by(name: target_audience_params[:name]) ).to be_nil
          end
      end
      
    end

    describe 'DELETE /target_audiences/:id' do
      let!(:target_audience) { create(:target_audience) }

      before do
          delete "/target_audiences/#{target_audience.id}", params: {}, headers: headers
      end
      
      it 'returns status code 204' do
          expect(response).to have_http_status(204)
      end

      it 'removes the target_audience from the database' do
          expect{ TargetAudience.find(target_audience.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
end