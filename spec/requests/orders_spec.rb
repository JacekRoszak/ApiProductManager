require 'rails_helper'

RSpec.describe '/orders', type: :request do
  
  Product.delete_all
  product = Product.create(name: 'test1', quantity: 999, code: 'test-1-test')
  
  User.delete_all
  user = User.create(login: 'test', password: 'test', admin: false)
  admin = User.create(login: 'admin', password: 'password', admin: true)

  describe '#index' do
    context 'with authentication' do
      it 'renders a successful response' do
        get orders_url(authentication_token: user.authentication_token), as: :json
        expect(response).to be_successful
      end
    end

    context 'without authentication' do
      it 'renders a successful response' do
        get orders_url, as: :json
        expect(response).not_to be_successful
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe '#create' do
    context 'witn authentication' do
      context 'with valid parameters' do
        it 'creates a new Order' do
          expect { post orders_url,
                        params: { authentication_token: user.authentication_token,
                                  user_id: user.id,
                                  quantity: 1,
                                  code: product.code }, as: :json
          }.to change(Order, :count).by(1)
          Order.last.destroy
        end

        it 'renders a JSON response with the new order' do
          post orders_url,
               params: { authentication_token: user.authentication_token,
                         user_id: user.id,
                         quantity: 1,
                         code: product.code }, as: :json
          expect(response).to have_http_status(:created)
        end
      end
    end
    context 'without authentication' do
      context 'with valid parameters' do
        it 'creates a new Order' do
          order_count = Order.count
          expect { post orders_url,
                        params: { user_id: user.id,
                                  quantity: 1,
                                  code: product.code }, as: :json
          }.not_to change(Order, :count).from(order_count)
        end

        it 'renders a JSON response with the new order' do
          post orders_url,
               params: { user_id: user.id,
                         quantity: 1,
                         code: product.code }, as: :json
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe '#destroy' do
    context 'not existing order' do
      it 'should return not_found status' do
        Order.find_by(id: 999)&.destroy
        delete order_url(id: 999), as: :json
        expect(response).to have_http_status(:not_found)
      end
    end
    context 'existing order' do
      context 'not by owner' do
        context 'not by admin' do
          it "shouldn't delete and should return :unauthorized ststus" do
            order = Order.create(user_id: admin.id, quantity: 1, code: product.code)
            order_count = Order.count
            expect {
              delete order_url(id: order.id,
                               authentication_token: user.authentication_token), as: :json
            }.not_to change(Order, :count).from(order_count)
            expect(response).to have_http_status(:unauthorized)
          end
        end
        context 'by admin' do
          it 'should destroy the requested order' do
            order = Order.create(user_id: user.id, quantity: 1, code: product.code)
            expect {
              delete order_url(id: order.id,
                               authentication_token: admin.authentication_token), as: :json
            }.to change(Order, :count).by(-1)
          end
        end
      end
      context 'by owner' do
        it 'should destroy the requested order' do
          order = Order.create(user_id: user.id, quantity: 1, code: product.code)
          expect {
            delete order_url(id: order.id,
                             authentication_token: user.authentication_token), as: :json
          }.to change(Order, :count).by(-1)
        end
      end
    end
  end
end
