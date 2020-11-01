class ProductsController < ApplicationController

  def index
    if params[:code]
      @products = Product.find_by(code: params[:code])
    else
      @products = Product.all
    end
    render json: @products
  end

  def create
    if current_user.admin
      @product = Product.new(name: params[:name],
                             quantity: params[:quantity],
                             code: params[:code])
      if @product.save
        render json: @product, status: :created
      else
        render json: @product.errors, status: :unprocessable_entity
      end
    else
      head(:unauthorized)
    end
  end

  def update
    if current_user.admin
      @product = Product.find_by(code: params[:code])
      if @product.update(name: params[:name],
                         quantity: params[:quantity])
        render json: @product
      else
        render json: @product.errors, status: :unprocessable_entity
      end
    else
      head(:unauthorized)
    end
  end
end
