require 'rails_helper'

RSpec.describe "/users", type: :request do
  let(:valid_attributes) {
    { login: 'test', password: 'test-1-test', admin: false }
  }
  let(:valid_attributes2) {
    { login: 'test3', password: 'test-3-test', admin: false }
  }
  let(:new_attributes) {
    { login: 'test2', password: 'test-2-test', admin: false }
  }
  let(:new_attributes_admin) {
    { login: 'test2', password: 'test-2-test', admin: true }
  }
  let(:invalid_attributes) {
    { login: '', password: '', admin: false }
  }

  User.delete_all

  describe "#index" do
    context 'with authorization' do
      it 'renders a successful response' do
        user = User.create(valid_attributes)
        get users_url(authentication_token: user.authentication_token), as: :json
        expect(response).to be_successful
        user.destroy
      end
    end
    context 'without authorization' do
      it 'renders a :unauthorized error' do
        user = User.create! valid_attributes
        get users_url, as: :json
        expect(response).to have_http_status(:unauthorized)
        user&.destroy
      end
    end
  end


  describe '#create' do
    context 'without authentication' do
      context 'with valid parameters' do
        context 'creating a admin user' do
          context 'without admin privileges' do
            it 'should create user without admin privileges' do
              expect {
                post users_url(login: 'not_admin',
                               password: 'not_admin',
                               admin: true), as: :json
              }.to change(User, :count).by(1)
              expect(User.last.admin).to eq(false)
              expect(response).to have_http_status(:created)
              User.delete_all
            end
          end
          context 'with admin privileges' do
            it 'should create a new admin user' do
              admin = User.create(login: 'admin', password: 'admin', admin: true)
              expect {
                post users_url(authentication_token: admin.authentication_token,
                               login: 'test_admin',
                               password: 'test_admin',
                               admin: true), as: :json
              }.to change(User, :count).by(1)
              expect(User.last.admin).to eq(true)
              expect(response).to have_http_status(:created)
              User.delete_all
            end
          end
        end
        context 'creating a simple user' do
          it 'should create a new user' do
            expect {
              post users_url(valid_attributes), as: :json
            }.to change(User, :count).by(1)
            expect(response).to have_http_status(:created)
            User.delete_all
          end
        end
      end

      context 'with invalid parameters' do
        it 'should return :unprocessable_entity error' do
          expect {
            post users_url(invalid_attributes), as: :json
          }.to change(User, :count).by(0)
          expect(response).to have_http_status(:unprocessable_entity)
          User.delete_all
        end
      end
    end
  end

  describe "#update" do
    context 'with authorization' do
      context 'updating existing user' do
        context 'with admin privileges' do
          context 'updating your own account' do
            context 'changing admin provileges' do
              it 'should update requested user changing admin privilages' do
                User.delete_all
                admin = User.create(login: 'testadmin', password: 'testadmin', admin: true)
                patch user_url(admin,
                               authentication_token: admin.authentication_token), params: new_attributes_admin, as: :json
                admin.reload
                expect(admin.login).to eq(new_attributes_admin[:login])
                expect(admin.admin).to eq(new_attributes_admin[:admin])
                expect(response).to have_http_status(:ok)
              end
          end
          end
          context "updating someone else's account" do
            context 'changing admin provileges' do
                it 'should update requested user changing admin privilages' do
                  User.delete_all
                  user = User.create(valid_attributes)
                  admin = User.create(login: 'testadmin', password: 'testadmin', admin: true)
                  patch user_url(user,
                                 authentication_token: admin.authentication_token), params: new_attributes_admin, as: :json
                  user.reload
                  expect(user.login).to eq(new_attributes_admin[:login])
                  expect(user.admin).to eq(new_attributes_admin[:admin])
                  expect(response).to have_http_status(:ok)
                end
              end
          end
        end
        context 'without admin privileges' do
          context 'updating your own account' do
            context 'changing admin privileges' do
              it 'should update requested user not changing admin privilages' do
                User.delete_all
                user = User.create(valid_attributes)
                patch user_url(user,
                               authentication_token: user.authentication_token), params: new_attributes_admin, as: :json
                user.reload
                expect(user.login).to eq(new_attributes_admin[:login])
                expect(user.admin).to eq(valid_attributes[:admin])
                expect(response).to have_http_status(:ok)
              end
            end
          end
          context "updating someone else's account" do
            it 'should return :unauthorized error' do
              User.delete_all
              user = User.create(valid_attributes)
              user2 = User.create(valid_attributes2)
              patch user_url(user,
                             authentication_token: user2.authentication_token), params: new_attributes, as: :json
              user.reload
              expect(user.login).not_to eq(new_attributes[:login])
              expect(response).to have_http_status(:unauthorized)
            end
          end
        end
      end
      context 'updating unexisting user' do
        it 'shoult return :not_found error' do
          User.delete_all
          user = User.new(valid_attributes)
          user.id = 99
          admin = User.create(new_attributes_admin)
          patch user_url(user, authentication_token: admin.authentication_token), params: new_attributes, as: :json
          expect(user.login).not_to eq(new_attributes[:login])
          expect(response).to have_http_status(:not_found)
        end
      end
    end
    context 'without authorization' do
      it 'should return :unauthorized error' do
        User.delete_all
        user = User.create(valid_attributes)
        patch user_url(user), params: new_attributes, as: :json
        user.reload
        expect(user.login).not_to eq(new_attributes[:login])
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid parameters' do
      it 'should update the requested user' do
        User.delete_all
        user = User.create(valid_attributes)
        patch user_url(user, authentication_token: user.authentication_token), params: new_attributes, as: :json
        user.reload
        expect(user.login).to eq(new_attributes[:login])
        expect(response).to have_http_status(:ok)
      end
    end
    context 'with invalid parameters' do
      it "renders a JSON response with errors for the user" do
        user = User.create(valid_attributes)
        patch user_url(user,
                       authentication_token: user.authentication_token), params: invalid_attributes, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
