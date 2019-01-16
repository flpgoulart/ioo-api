require 'rails_helper'

# este comando serve para descrever o que o teste
RSpec.describe 'Products API', type: :request do
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

    describe 'GET /products' do

        context 'when no filter param is sent' do
        
            before do
                # é do FactoryGirl, serve para criar vários cadastros do mesmo objeto
                # neste caso, ele vai criar 5x, de acordo com o que foi parametrizado no factories/tasks
                create_list(:product, 5)
                get '/products', params: {}, headers: headers 
            end
            
            it 'returns status code 200' do
                expect(response).to have_http_status(200)  
            end

            it 'returns 5 products from database' do
                expect(json_body[:data].count).to eq(5)
            end
        
        end 

        context 'when filter and sorting params is sent' do
            let!(:notebook_se_1) { create(:product, name: 'Check if the notebook is broken' ) }
            let!(:notebook_se_2) { create(:product, name: 'Buy a new notebook' ) }
            let!(:other_se_1)    { create(:product, name: 'Fix the door' ) }
            let!(:other_se_2)    { create(:product, name: 'Buy a new car' ) }

            before do
                get '/products?q[name_cont]=note&q[s]=name+ASC', params: {}, headers: headers
            end
            
            it 'returns only the products matching and in the correct order' do
                returned_se_names = json_body[:data].map { |t| t[:attributes][:name] } #map serve para navegar entre os itens do array

                expect(returned_se_names).to eq([notebook_se_2.name, notebook_se_1.name])  
            end

        end

    end
    
    describe 'GET /products/:id' do
        let(:product) {create(:product)}

        before { get "/products/#{product.id}", params: {}, headers: headers }

        it 'returns status code 200' do
            expect(response).to have_http_status(200)
        end

        it 'returns the json for products' do
            expect(json_body[:data][:attributes][:name]).to eq(product.name)
        end
        
    end
    
    describe 'POST /products' do
        before do
            post '/products', params: { product: product_params }.to_json, headers: headers
        end
        
        context 'when the params are valid' do
            let(:subcategory) { create(:subcategory)}
            let(:product_params) { attributes_for(:product, subcategory_id: subcategory.id ) } 

            it 'save the product in the database' do
                expect( Product.find_by( name: product_params[:name] ) ).not_to be_nil 
            end

            it 'returns the json for created product' do
                expect(json_body[:data][:attributes][:name]).to eq(product_params[:name])
            end

#            it 'assigns the created social_entity to the current user' do
#                expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)
#            end
        end

        context 'when the params are invalid' do
            let(:subcategory) { create(:subcategory)}
            let(:product_params) { attributes_for(:product, name: ' ', subcategory_id: subcategory.id) }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'does not save the product in the database' do
                expect( Product.find_by( name: product_params[:name] ) ).to be_nil 
            end

            # neste teste, ele especifica que quer especificamente o erro no titulo
            it 'returns the json errors for name' do
                expect(json_body[:errors]).to have_key(:name)
            end
        end
    end
    
    describe 'PUT /products/:id' do
      let!(:product) { create(:product) }
      before do
          put "/products/#{product.id}", params: { product: product_params }.to_json, headers: headers
      end
      
      context 'when the params are valid' do
          let(:product_params) { { name: 'New product name' } }

          it 'return status code 200' do
            expect(response).to have_http_status(200) 
          end

          it 'returns the json for updated products' do
            expect(json_body[:data][:attributes][:name]).to eq(product_params[:name])
          end

          it 'updates the product in the database' do 
            expect(Product.find_by(name: product_params[:name])).not_to be_nil 
          end
      end
    
      context 'when the params are invalid' do
          let(:product_params) { { name: ' ' } }

          it 'return status code 422' do
            expect(response).to have_http_status(422) 
          end

          it 'returns the json error for name' do
            expect(json_body[:errors]).to have_key(:name)
          end

          it 'does not update the product in the database' do
            expect( Product.find_by(name: product_params[:name]) ).to be_nil
          end
      end
      
    end

    describe 'DELETE /products/:id' do
      let!(:product) { create(:product) }

      before do
          delete "/products/#{product.id}", params: {}, headers: headers
      end
      
      it 'returns status code 204' do
          expect(response).to have_http_status(204)
      end

      it 'removes the product from the database' do
          expect{ Product.find(product.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
end