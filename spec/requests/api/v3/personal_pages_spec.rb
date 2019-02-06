require 'rails_helper'

# este comando serve para descrever o que o teste
RSpec.describe 'PersonalPages API', type: :request do
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

    describe 'GET /personal_pages' do

        context 'when no filter param is sent' do
        
            before do
                # é do FactoryGirl, serve para criar vários cadastros do mesmo objeto
                # neste caso, ele vai criar 5x, de acordo com o que foi parametrizado no factories/tasks
                create_list(:personal_page, 5, user_id: user.id)
                get '/personal_pages', params: {}, headers: headers 
            end
            
            it 'returns status code 200' do
                expect(response).to have_http_status(200)  
            end

            it 'returns 5 personal page from database' do
                expect(json_body[:data].count).to eq(5)
            end
        
        end 

    end
    
    # describe 'GET /personal_pages/:id' do
    #     let(:personal_page) {create(:personal_page)}

    #     before { get "/personal_pages/#{personal_page.id}", params: {}, headers: headers }

    #     it 'returns status code 200' do
    #         expect(response).to have_http_status(200)
    #     end

    # end
    
    describe 'POST /personal_pages' do
        before do
            post '/personal_pages', params: { personal_page: personal_page_params }.to_json, headers: headers
        end
        
        context 'when the params are valid' do
            let(:category) { create(:category)}
            let(:personal_page_params) { attributes_for(:personal_page, category_id: category.id, user_id: user.id ) } 

            it 'save the personal page in the database' do
                expect( PersonalPage.find_by( category_id: personal_page_params[:category_id] ) ).not_to be_nil 
            end

            it 'returns the json for created personal page' do
                expect(json_body[:data][:attributes][:'category-id']).to eq(personal_page_params[:category_id])
            end

            it 'assigns the created personal page to the current user' do
                expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)
            end
        end

        context 'when the params are invalid' do
            let(:category) { create(:category)}
            let(:personal_page_params) { attributes_for(:personal_page, category_id: ' ', user_id: user.id) }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'does not save the personal page in the database' do
                expect( PersonalPage.find_by( category_id: personal_page_params[:category_id] ) ).to be_nil 
            end

            # neste teste, ele especifica que quer especificamente o erro no category_id
            it 'returns the json errors for name' do
                expect(json_body[:errors]).to have_key(:category_id)
            end
        end
    end
    
    # describe 'PUT /subcategories/:id' do
    #   let!(:subcategory) { create(:subcategory) }
    #   before do
    #       put "/subcategories/#{subcategory.id}", params: { subcategory: subcategory_params }.to_json, headers: headers
    #   end
      
    #   context 'when the params are valid' do
    #       let(:subcategory_params) { { name: 'New subcategory name' } }

    #       it 'return status code 200' do
    #         expect(response).to have_http_status(200) 
    #       end

    #       it 'returns the json for updated subcategories' do
    #         expect(json_body[:data][:attributes][:name]).to eq(subcategory_params[:name])
    #       end

    #       it 'updates the subcategory in the database' do 
    #         expect(Subcategory.find_by(name: subcategory_params[:name])).not_to be_nil 
    #       end
    #   end
    
    #   context 'when the params are invalid' do
    #       let(:subcategory_params) { { name: ' ' } }

    #       it 'return status code 422' do
    #         expect(response).to have_http_status(422) 
    #       end

    #       it 'returns the json error for name' do
    #         expect(json_body[:errors]).to have_key(:name)
    #       end

    #       it 'does not update the category in the database' do
    #         expect( Subcategory.find_by(name: subcategory_params[:name]) ).to be_nil
    #       end
    #   end
      
    # end

    describe 'DELETE /personal_page/:id' do
      let!(:personal_page) { create(:personal_page, user_id: user.id) }

      before do
          delete "/personal_pages/#{personal_page.id}", params: {}, headers: headers
      end
      
      it 'returns status code 204' do
          expect(response).to have_http_status(204)
      end

      it 'removes the personal page from the database' do
          expect{ PersonalPage.find(personal_page.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
end