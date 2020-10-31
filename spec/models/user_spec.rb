require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#validations' do
    
    it 'should validate the presence of the login' do
      user = FactoryBot.build :user, login: ''
      expect(user).not_to be_valid
      expect(user.errors.messages[:login]).to include("can't be blank")
    end
    
    it 'should validate uniqueness of the login' do
      user = FactoryBot.create :user
      invalid_user = FactoryBot.build :user, login: user.login
      expect(invalid_user).not_to be_valid
    end

  end
end
