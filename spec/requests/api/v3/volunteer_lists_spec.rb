require 'rails_helper'

# este comando serve para descrever o que o teste
RSpec.describe 'Volunteer List API', type: :request do
    before { host! 'api.hopii.test' }
    
    let!(:user) { create(:user) }
    let!(:volunteer) { create(:volunteer) }
    let!(:improvement) { create(:improvement) }
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

    describe 'GET /volunteer_lists' do

        before do
            # é do FactoryGirl, serve para criar vários cadastros do mesmo objeto
            # neste caso, ele vai criar 5x, de acordo com o que foi parametrizado no factories/tasks
            create_list(:volunteer_list, 5)
            get '/volunteer_lists', params: {}, headers: headers 
        end
        
        it 'returns status code 200' do
            expect(response).to have_http_status(200)  
        end

        it 'returns 5 volunteer lists from database' do
            expect(json_body[:data].count).to eq(5)
        end

    end
    
    describe 'GET /volunteer_lists/:id' do
        let(:volunteer_list) {create(:volunteer_list)}

        before { get "/volunteer_lists/#{volunteer_list.id}", params: {}, headers: headers }

        it 'returns status code 200' do
            expect(response).to have_http_status(200)
        end

        it 'returns the json for volunteer lists' do
            expect(json_body[:data][:attributes][:attendance]).to eq(volunteer_list.attendance)
        end
        
    end
    
    describe 'POST /volunteer_lists' do
        before do
            post '/volunteer_lists', params: { volunteer_list: volunteer_list_params }.to_json, headers: headers
        end
        
        context 'when the params are valid' do
            let(:volunteer_list_params) { attributes_for(:volunteer_list, volunteer_id: volunteer.id, improvement_id: improvement.id ) } 

            
            it 'save the volunteer list in the database' do
                expect( VolunteerList.find_by( rate_volunteer: volunteer_list_params[:rate_volunteer] ) ).not_to be_nil 
            end

            it 'returns the json for created volunteer list' do
                expect(json_body[:data][:attributes][:"rate-volunteer"].to_s).to eq(volunteer_list_params[:rate_volunteer])
            end

        end

        context 'when the params are invalid' do
            let(:volunteer_list_params) { attributes_for(:volunteer, volunteer_id: ' ', improvement_id: improvement.id) }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'does not save the volunteer list in the database' do
                expect( VolunteerList.find_by( id: volunteer_list_params[:id] ) ).to be_nil 
            end

            # neste teste, ele especifica que quer especificamente o erro no titulo
            it 'returns the json errors for volunteer id' do
                expect(json_body[:errors]).to have_key(:volunteer_id)
            end
        end
        
        
    end
    
    describe 'PUT /volunteer_lists/:id' do
      let!(:volunteer_list) { create(:volunteer_list) }
      before do
          put "/volunteer_lists/#{volunteer_list.id}", params: { volunteer_list: volunteer_list_params }.to_json, headers: headers
      end
      
      context 'when the params are valid' do
          let(:volunteer_list_params) { { rate_volunteer: 10 } }

          it 'return status code 200' do
            expect(response).to have_http_status(200) 
          end

          it 'returns the json for updated volunteer list' do
            expect(json_body[:data][:attributes][:"rate-volunteer"]).to eq(volunteer_list_params[:rate_volunteer])
          end

          it 'updates the volunteer list in the database' do 
            expect(VolunteerList.find_by(rate_volunteer: volunteer_list_params[:rate_volunteer])).not_to be_nil 
          end
      end
    
      context 'when the params are invalid' do
          let(:volunteer_list_params) { { improvement_id: ' ' } }

          it 'return status code 422' do
            expect(response).to have_http_status(422) 
          end

          it 'returns the json error for improvement id' do
            expect(json_body[:errors]).to have_key(:improvement_id)
          end

          it 'does not update the volunteer in the database' do
            expect( VolunteerList.find_by(improvement_id: volunteer_list_params[:improvement_id]) ).to be_nil
          end
      end
      
    end

    describe 'DELETE /volunteer_lists/:id' do
      let!(:volunteer_list) { create(:volunteer_list) }

      before do
          delete "/volunteer_lists/#{volunteer_list.id}", params: {}, headers: headers
      end
      
      it 'returns status code 204' do
          expect(response).to have_http_status(204)
      end

      it 'removes the volunteer list from the database' do
          expect{ VolunteerList.find(volunteer_list.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
end