require 'rails_helper'

RSpec.describe '/orders', type: :request do
  Product.delete_all
  product = Product.create(name: 'test1', quantity: 2, code: 'test-1-test')
  User.delete_all
  user = User.create(login: 'test', password: 'test', admin: false)
  order = Order.create!(user_id: user.id, quantity: 1, code: product.code)

  let(:valid_attributes) {
    { user_id: user.id, quantity: 1, code: product.code }
  }

  let(:invalid_attributes) {
    { user_id: 1, quantity: 0, code: 'bad-code' }
  }

  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # OrdersController, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) {
    {}
  }

  describe '#index' do
    it 'renders a successful response' do
      get orders_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe '#show' do
    it 'renders a successful response' do
      get order_url(order), as: :json
      expect(response).to be_successful
    end
  end

  describe '#create' do
    context 'with valid parameters' do
      it 'creates a new Order' do
        User.delete_all
        user = User.create(login: 'test', password: 'test', admin: false)
        expect {
          post orders_url,
               params: { order: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Order, :count).by(1)
      end

      it 'renders a JSON response with the new order' do
        User.delete_all
        user = User.create(login: 'test', password: 'test', admin: false)
        post orders_url,
             params: { order: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json; charset=utf-8'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Order' do
        expect {
          post orders_url,
               params: { order: invalid_attributes }, as: :json
        }.to change(Order, :count).by(0)
      end

      it 'renders a JSON response with errors for the new order' do
        post orders_url,
             params: { order: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe '#update' do
    context 'with valid parameters' do
      let(:new_attributes) {
        skip('Add a hash of attributes valid for your model')
      }

      it 'updates the requested order' do
        Order.delete_all
        User.delete_all
        user = User.create(login: 'test', password: 'test', admin: false)
        order = Order.create!(user_id: user.id, quantity: 1, code: product.code)
        patch order_url(order),
              params: { order: {user_id: user.id, quantity: 2, code: product.code} }, headers: valid_headers, as: :json
        order.reload
        expect(order.quantity).to eq(2)  
      end

      it 'renders a JSON response with the order' do
        Order.delete_all
        User.delete_all
        user = User.create(login: 'test', password: 'test', admin: false)
        order = Order.create!(user_id: user.id, quantity: 1, code: product.code)
        patch order_url(order),
              params: { order: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the order' do
        Order.delete_all
        User.delete_all
        user = User.create(login: 'test', password: 'test', admin: false)
        order = Order.create!(user_id: user.id, quantity: 1, code: product.code)
        patch order_url(order),
              params: { order: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested order' do
      Order.delete_all
      User.delete_all
      user = User.create(login: 'test', password: 'test', admin: false)
      order = Order.create!(user_id: user.id, quantity: 1, code: product.code)
      expect {
        delete order_url(order), headers: valid_headers, as: :json
      }.to change(Order, :count).by(-1)
    end
  end
end
