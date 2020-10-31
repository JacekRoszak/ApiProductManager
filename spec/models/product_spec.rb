require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#validations' do
    
    it 'should validate the presence of the quantity' do
      product = FactoryBot.build :product, quantity: nil
      expect(product).not_to be_valid
      expect(product.errors.messages[:quantity]).to include("can't be blank")
    end
    
    it 'should validate the presence of the code' do
      product = FactoryBot.build :product, code: ''
      expect(product).not_to be_valid
      expect(product.errors.messages[:code]).to include("can't be blank")
    end
    
    it 'should validate the presence of the name' do
      product = FactoryBot.build :product, name: ''
      expect(product).not_to be_valid
      expect(product.errors.messages[:name]).to include("can't be blank")
    end

    it 'should validate uniqueness of the code' do
      product = FactoryBot.create :product
      invalid_product = FactoryBot.build :product, code: product.code
      expect(invalid_product).not_to be_valid
    end

    it 'should validate uniqueness of the name' do
      product = FactoryBot.create :product
      invalid_product = FactoryBot.build :product, name: product.name
      expect(invalid_product).not_to be_valid
    end

    it 'should validate numericality of the quantity' do
      product = FactoryBot.build :product, quantity: 1
      invalid_product = FactoryBot.build :product, quantity: 0
      expect(product).to be_valid
      expect(invalid_product).not_to be_valid
    end
  end
end
