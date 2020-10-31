require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#validations' do
    it 'should validate the presence of the quantity' do
      order = FactoryBot.build :order, quantity: nil
      expect(order).not_to be_valid
      expect(order.errors.messages[:quantity]).to include("can't be blank")
    end
    
    it 'should validate the presence of the code' do
      order = FactoryBot.build :order, code: ''
      expect(order).not_to be_valid
      expect(order.errors.messages[:code]).to include("can't be blank")
    end
    
    it 'should validate the presence of the user_id' do
      order = FactoryBot.build :order, user_id: ''
      expect(order).not_to be_valid
      expect(order.errors.messages[:user_id]).to include("can't be blank")
    end

    it 'should validate numericality of the quantity' do
      User.delete_all
      user = User.create(login: 'test', password_digest: 'test', password_confirmation: 'test', admin: false)
      Product.delete_all
      product = FactoryBot.create :product
      order = FactoryBot.build :order, quantity: 5, user_id: user.id, code: product.code
      invalid_order = FactoryBot.build :order, quantity: 0, user_id: user.id, code: product.code
      expect(order).to be_valid
      expect(invalid_order).not_to be_valid
    end
  end
end
