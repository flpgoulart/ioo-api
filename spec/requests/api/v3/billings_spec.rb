#não usar como exemplo, testes estão incompletos
require 'rails_helper'

# este comando serve para descrever o que o teste
RSpec.describe 'Billings API', type: :request do
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

    describe 'GET /billings' do

        context 'when no filter param is sent' do
        
            before do
                # é do FactoryGirl, serve para criar vários cadastros do mesmo objeto
                # neste caso, ele vai criar 5x, de acordo com o que foi parametrizado no factories/tasks
                create_list(:billing, 5, user_id: user.id)
                get '/billings', params: {}, headers: headers 
            end
            
            it 'returns status code 200' do
                expect(response).to have_http_status(200)  
            end

            it 'returns 5 billings from database' do
                expect(json_body[:data].count).to eq(5)
            end
        
        end 

    end
    
    describe 'GET /billings/:id' do
        let(:billing) {create(:billing, user_id: user.id)}

        before { get "/billings/#{billing.id}", params: {}, headers: headers }

        it 'returns status code 200' do
            expect(response).to have_http_status(200)
        end

        it 'returns the json for billing' do
            expect(json_body[:data][:attributes][:document]).to eq(billing.document)
        end
        
    end
    
    describe 'POST /billings' do
        before do
            post '/billings', params: { billing: billing_params }.to_json, headers: headers
        end
        
        context 'when the params are valid' do
            let(:billing_params) { attributes_for(:billing) } 

            it 'save the billing in the database' do
                expect( Billing.find_by( document: billing_params[:document] ) ).not_to be_nil 
            end

            it 'returns the json for created billing' do
                expect(json_body[:data][:attributes][:document]).to eq(billing_params[:document])
            end

           it 'assigns the created billing to the current user' do
               expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)
           end
        end

        context 'when the params are invalid' do
            let(:billing_params) { attributes_for(:billing, document: ' ') }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'does not save the billing in the database' do
                expect( Billing.find_by( document: billing_params[:document] ) ).to be_nil 
            end

            # neste teste, ele especifica que quer especificamente o erro no titulo
            it 'returns the json errors for document' do
                expect(json_body[:errors]).to have_key(:document)
            end
        end
        
    end
    
    describe 'PUT /billings/:id' do
      let!(:billing) { create(:billing, user_id: user.id) }
      before do
          put "/billings/#{billing.id}", params: { billing: billing_params }.to_json, headers: headers
      end
      
      context 'when the params are valid' do
          let(:billing_params) { { document: 'New billing document' } }

          it 'return status code 200' do
            expect(response).to have_http_status(200) 
          end

          it 'returns the json for updated billing' do
            expect(json_body[:data][:attributes][:document]).to eq(billing_params[:document])
          end

          it 'updates the billing in the database' do 
            expect(Billing.find_by(document: billing_params[:document])).not_to be_nil 
          end
      end
    
      context 'when the params are invalid' do
          let(:billing_params) { { document: ' ' } }

          it 'return status code 422' do
            expect(response).to have_http_status(422) 
          end

          it 'returns the json error for document' do
            expect(json_body[:errors]).to have_key(:document)
          end

          it 'does not update the billing in the database' do
            expect( Billing.find_by(document: billing_params[:document]) ).to be_nil
          end
      end
      
    end

    describe 'DELETE /billings/:id' do
      let!(:billing) { create(:billing, user_id: user.id) }

      before do
          delete "/billings/#{billing.id}", params: {}, headers: headers
      end
      
      it 'returns status code 204' do
          expect(response).to have_http_status(204)
      end

      it 'removes the billing from the database' do
          expect{ Billing.find(billing.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
end