require 'rails_helper'

# este comando serve para descrever o que o teste
RSpec.describe 'Shopping List Offers  API', type: :request do
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

    describe 'GET /shopping_list_offers' do

        context 'when no filter param is sent' do
        
            before do
                # é do FactoryGirl, serve para criar vários cadastros do mesmo objeto
                # neste caso, ele vai criar 5x, de acordo com o que foi parametrizado no factories/tasks
                create_list(:shopping_list_offer, 5, user_id: user.id)
                get '/shopping_list_offers', params: {}, headers: headers 
            end
            
            it 'returns status code 200' do
                expect(response).to have_http_status(200)  
            end

            it 'returns 5 shopping list offers from database' do
                expect(json_body[:data].count).to eq(5)
            end
        
        end 

    end
    
    describe 'GET /shopping_list_offers/:id' do
        let(:shopping_list_offer) {create(:shopping_list_offer, user_id: user.id)}

        before { get "/shopping_list_offers/#{shopping_list_offer.id}", params: {}, headers: headers }

        it 'returns status code 200' do
            expect(response).to have_http_status(200)
        end

        it 'returns the json for shopping list offer' do
            expect(json_body[:data][:attributes][:status]).to eq(shopping_list_offer.status)
        end
        
    end
    
    describe 'POST /shopping_list_offers' do
        before do
            post '/shopping_list_offers', params: { shopping_list_offer: shopping_list_offer_params }.to_json, headers: headers
        end
        
        context 'when the params are valid' do

            let(:shopping_list) { create(:shopping_list)}
            let(:offer) { create(:offer)}

            let(:shopping_list_offer_params) { attributes_for(:shopping_list_offer, user_id: user.id, shopping_list_id: shopping_list.id, offer_id: offer.id ) } 

            it 'save the shopping list offer in the database' do
                expect( ShoppingListOffer.find_by( status: shopping_list_offer_params[:status] ) ).not_to be_nil 
            end

            it 'returns the json for created shopping list offer' do
                expect(json_body[:data][:attributes][:status]).to eq(shopping_list_offer_params[:status])
            end

           it 'assigns the created shopping list offer to the current user' do
               expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)
           end
        end

        context 'when the params are invalid' do
            let(:shopping_list_offer_params) { attributes_for(:shopping_list_offer, status: ' ', user_id: user.id) }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'does not save the shopping list offer in the database' do
                expect( ShoppingListOffer.find_by( status: shopping_list_offer_params[:status] ) ).to be_nil 
            end

            # neste teste, ele especifica que quer especificamente o erro no titulo
            it 'returns the json errors for status' do
                expect(json_body[:errors]).to have_key(:status)
            end
        end
        
    end
    
    describe 'PUT /shopping_list_offers/:id' do
      let!(:shopping_list_offer) { create(:shopping_list_offer, user_id: user.id) }
      before do
          put "/shopping_list_offers/#{shopping_list_offer.id}", params: { shopping_list_offer: shopping_list_offer_params }.to_json, headers: headers
      end
      
      context 'when the params are valid' do
          let(:shopping_list_offer_params) { { status: 'P' } }

          it 'return status code 200' do
            expect(response).to have_http_status(200) 
          end

          it 'returns the json for updated shopping list offer' do
            expect(json_body[:data][:attributes][:status]).to eq(shopping_list_offer_params[:status])
          end

          it 'updates the shopping list offer in the database' do 
            expect(ShoppingListOffer.find_by(status: shopping_list_offer_params[:status])).not_to be_nil 
          end
      end
    
      context 'when the params are invalid' do
          let(:shopping_list_offer_params) { { status: ' ' } }

          it 'return status code 422' do
            expect(response).to have_http_status(422) 
          end

          it 'returns the json error for status' do
            expect(json_body[:errors]).to have_key(:status)
          end

          it 'does not update the shopping list offer in the database' do
            expect( ShoppingListOffer.find_by(status: shopping_list_offer_params[:status]) ).to be_nil
          end
      end
      
    end

#     describe 'DELETE /campaigns/:id' do
#       let!(:campaign) { create(:campaign) }

#       before do
#           delete "/campaigns/#{campaign.id}", params: {}, headers: headers
#       end
      
#       it 'returns status code 204' do
#           expect(response).to have_http_status(204)
#       end

#       it 'removes the campaign from the database' do
#           expect{ StoreType.find(campaign.id) }.to raise_error(ActiveRecord::RecordNotFound)
#       end
#     end
end