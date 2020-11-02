require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  before(:each) do
    User.delete_all
    @user = User.create(login: 'test', password: 'test', admin: false)
  end

  describe '#create' do
    context 'with valid parameters' do
      it 'should create a new Session' do
        post sessions_url, params: { login: @user.login,
                                     password: 'test' }, as: :json
        expect(response).to have_http_status(:created)
      end
    end
    context 'with invalid parameters' do
      it 'should return a :unauthorized error' do
        post sessions_url, params: { login: @user.login,
                                     password: 'wrong_password' }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
