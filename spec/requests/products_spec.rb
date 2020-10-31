require 'rails_helper'

RSpec.describe '/products', type: :request do
  let(:valid_attributes) {
    { name: 'test', code: 'test-1-test', quantity: 1 }
  }

  let(:invalid_attributes) {
    { name: '', code: '', quantity: 0 }
  }

  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # ProductsController, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) {
    {}
  }
  Product.delete_all

  describe '#index' do
    it 'renders a successful response' do
      Product.create! valid_attributes
      get products_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe '#show' do
    it 'renders a successful response' do
      product = Product.create! valid_attributes
      get product_url(product), as: :json
      expect(response).to be_successful
    end
  end

  describe '#create' do
    context 'with valid parameters' do
      it 'creates a new Product' do
        expect {
          post products_url,
               params: { product: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Product, :count).by(1)
      end

      it 'renders a JSON response with the new product' do
        post products_url,
             params: { product: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json; charset=utf-8'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Product' do
        expect {
          post products_url,
               params: { product: invalid_attributes }, as: :json
        }.to change(Product, :count).by(0)
      end

      it 'renders a JSON response with errors for the new product' do
        post products_url,
             params: { product: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe '#update' do
    context 'with valid parameters' do
      let(:new_attributes) {
        { name: 'test2', code: 'test-2-test', quantity: 2 }
      }

      it 'updates the requested product' do
        product = Product.create! valid_attributes
        patch product_url(product),
              params: { product: new_attributes }, headers: valid_headers, as: :json
        product.reload
        expect(product.name).to eq('test2')  
      end

      it 'renders a JSON response with the product' do
        product = Product.create! valid_attributes
        patch product_url(product),
              params: { product: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the product' do
        product = Product.create! valid_attributes
        patch product_url(product),
              params: { product: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end
end
