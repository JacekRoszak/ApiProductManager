class OrdersController < ApplicationController

  def index
    @orders = current_user.admin ? Order : @current_user.orders
    if params[:code]
      @orders = @orders.where(code: params[:code])
    end
    render json: @orders.all.reverse
  end

  def create
    @product = Product.find_by(code: params[:code])
    if @product
      # products quantity has to be greater than 0
      if @product.quantity > params[:quantity].to_i
        @order = Order.new(code: params[:code],
                           quantity: params[:quantity].to_i,
                           user_id: current_user.id)
        if @order.save
          @product = Product.find_by(code: params[:code])
          @product.quantity = @product.quantity - @order.quantity
          @product.save
          render json: @order, status: :created
        else
          render json: @order.errors, status: :unprocessable_entity
        end
      else
        render json: { message: 'You cannot place the order. There is not enough product in the stock.' },
               status: :bad_request
      end
    else
      head(:not_found)
    end
  end

  def destroy
    @order = Order.find_by(id: params[:id])
    if @order
      if @order.user_id == current_user.id || current_user.admin
        @product = Product.find_by(code: @order.code)
        @product.update(quantity: @product.quantity + @order.quantity)
        @order.destroy
        head(:ok)
      else
        head(:unauthorized)
      end
    else
      head(:not_found)
    end
  end
end