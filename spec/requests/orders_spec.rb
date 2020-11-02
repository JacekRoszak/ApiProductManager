require 'rails_helper'

RSpec.describe '/orders', type: :request do
  
  before(:each) do
    User.delete_all
    @admin = User.create(login: 'admin', password: 'password', admin: true)
    @user = User.create(login: 'user', password: 'password', admin: false)
    Product.delete_all
    @product = Product.create(name: 'test1', quantity: 999, code: 'test-1-test')
  end

  describe '#index' do
    context 'with authentication' do
      it 'renders a successful response' do
        get orders_url(authentication_token: @user.authentication_token), as: :json
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
    context 'with authentication' do
      context 'with valid parameters' do
        it 'should create a new Order' do
          expect { post orders_url(authentication_token: @user.authentication_token),
                        params: { user_id: @user.id,
                                  quantity: 1,
                                  code: @product.code }, as: :json
          }.to change(Order, :count).by(1)
          expect(response).to have_http_status(:created)
        end
      end

      context 'for not existing product' do
        it 'should return :not_found error' do
          expect { post orders_url,
                        params: { authentication_token: @user.authentication_token,
                                  user_id: @user.id,
                                  quantity: 1,
                                  code: '' }, as: :json
          }.to change(Order, :count).by(0)
          expect(response).to have_http_status(:not_found)
        end
      end
      context 'for out of stock situation' do
        it 'should return :bad_request error' do
          Product.create(name: 'out_of_stock_product',
                         quantity: 1,
                         code: 'out_of_stock_product')
          expect { post orders_url,
                        params: { authentication_token: @user.authentication_token,
                                  user_id: @user.id,
                                  quantity: 10,
                                  code: 'out_of_stock_product' }, as: :json
          }.to change(Order, :count).by(0)
          expect(response).to have_http_status(:bad_request)
        end
      end

    end
    context 'without authentication' do
      context 'with valid parameters' do
        it 'creates a new Order' do
          order_count = Order.count
          expect { post orders_url,
                        params: { user_id: @user.id,
                                  quantity: 1,
                                  code: @product.code }, as: :json
          }.not_to change(Order, :count).from(order_count)
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe '#destroy' do
    context 'without authentication' do
      it "shouldn't destroy the requested order, should return :unauthorized status" do
        order = Order.create(user_id: @user.id, quantity: 1, code: @product.code)
        order_count = Order.count
        expect {
          delete order_url(id: order.id,), as: :json
        }.not_to change(Order, :count).from(order_count)
        expect(response).to have_http_status(:unauthorized)
      end
    end
    context 'with authentication' do
      context 'not existing order' do
        it 'should return not_found status' do
          Order.find_by(id: 999)&.destroy
          invalid_order = Order.new(id: 999, user_id: 1, quantity: 1, code: 'test')
          delete order_url(invalid_order, authentication_token: @admin.authentication_token), as: :json
          expect(response).to have_http_status(:not_found)
        end
      end
      context 'existing order' do
        context 'not by owner' do
          context 'not by admin' do
            it "shouldn't delete and should return :unauthorized ststus" do
              order = Order.create(user_id: @admin.id, quantity: 1, code: @product.code)
              order_count = Order.count
              expect {
                delete order_url(id: order.id,
                                authentication_token: @user.authentication_token), as: :json
              }.not_to change(Order, :count).from(order_count)
              expect(response).to have_http_status(:unauthorized)
            end
          end
          context 'by admin' do
            it 'should destroy the requested order' do
              order = Order.create(user_id: @user.id, quantity: 1, code: @product.code)
              expect {
                delete order_url(id: order.id,
                                authentication_token: @admin.authentication_token), as: :json
              }.to change(Order, :count).by(-1)
            end
          end
        end
        context 'by owner' do
          it 'should destroy the requested order' do
            order = Order.create(user_id: @user.id, quantity: 1, code: @product.code)
            expect {
              delete order_url(id: order.id,
                              authentication_token: @user.authentication_token), as: :json
            }.to change(Order, :count).by(-1)
          end
        end
      end
    end
  end
end
