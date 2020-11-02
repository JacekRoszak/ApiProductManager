require 'rails_helper'

RSpec.describe '/products', type: :request do
  let(:valid_attributes) {
    { name: 'test_product', code: 'test-1-test', quantity: 1 }
  }
  let(:invalid_attributes) {
    { name: '', code: 'test-1-test', quantity: 0 }
  }
  let(:new_attributes) {
    { name: 'test2', code: 'test-1-test', quantity: 2 }
  }

  before(:each) do
    Product.delete_all
    User.delete_all
    @user = User.create(login: 'test', password: 'test', admin: false)
    @admin = User.create(login: 'admin', password: 'test', admin: true)
  end

  describe '#index' do
    context 'with authorization' do
      it 'renders a successful response' do
        Product.create(valid_attributes)
        get products_url(authentication_token: @user.authentication_token), as: :json
        expect(response).to be_successful
      end
    end
    context 'without authorization' do
      it 'renders a successful response' do
        Product.create(valid_attributes)
        get products_url, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe '#create' do
    context 'with authentication' do
      context 'with admin privileges' do
        context 'with valid parameters' do
          it 'should create a new Product' do
            expect { post products_url(authentication_token: @admin.authentication_token),
                          params: valid_attributes, as: :json
            }.to change(Product, :count).by(1)
            expect(response).to have_http_status(:created)
          end
        end
        context 'with invalid parameters' do
          it 'should not create a new Product, should return :unprocessable_entity error' do
            expect {
              post products_url(authentication_token: @admin.authentication_token),
                   params: { product: invalid_attributes }, as: :json
            }.to change(Product, :count).by(0)
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
      context 'without admin privileges' do
        it 'should return :unauthorized error' do
          expect {
            post products_url,
                 params: { product: valid_attributes }, as: :json
          }.to change(Product, :count).by(0)
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
    context 'without authentication' do
      it 'should return :unauthorized error' do
        expect {
          post products_url,
               params: { product: valid_attributes }, as: :json
        }.to change(Product, :count).by(0)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe '#update' do
    context 'with authorization' do
      context 'with admin privileges' do
        context 'changing existing product' do
          context 'with valid parameters' do
            it 'should update the requested product' do
              product = Product.create(valid_attributes)
              patch products_url(product, authentication_token: @admin.authentication_token),
                    params: new_attributes, as: :json
              product.reload
              expect(product.name).to eq(new_attributes[:name])
              expect(product.quantity).to eq(new_attributes[:quantity])
              expect(response).to have_http_status(:ok)
            end
          end
          context 'with invalid parameters' do
            it 'should return :unprocessable_entity' do
              product = Product.create(valid_attributes)
              patch products_url(product, authentication_token: @admin.authentication_token),
                    params: invalid_attributes, as: :json
              product.reload
              expect(response).to have_http_status(:unprocessable_entity)
            end
          end
        end
        context 'changing unexisting product' do
          it 'should return :not_found error' do
            product = Product.new(valid_attributes)
            product.id = 99
            patch products_url(product, authentication_token: @admin.authentication_token),
                    params: new_attributes, as: :json
            expect(response).to have_http_status(:not_found)
          end
        end
      end
      context 'without admin privileges' do
        it 'should return :unauthorized error' do
          product = Product.create(valid_attributes)
          patch products_url(product, authentication_token: @user.authentication_token),
                params: new_attributes, as: :json
          product.reload
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
    context 'without authorization' do
      it 'should return :unauthorized error' do
        product = Product.create(valid_attributes)
        patch products_url(product),
              params: new_attributes, as: :json
        product.reload
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
