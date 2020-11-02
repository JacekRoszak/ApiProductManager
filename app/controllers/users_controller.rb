class UsersController < ApplicationController
  skip_before_action :authenticate_with_token, only: :create

  def updating_yourself
    User.find_by(authentication_token: params[:authentication_token]) == User.find_by(id: params[:id])
  end

  def index
    @users = params[:login] ? User.where(login: params[:login]) : User.all
    render json: @users
  end

  def create
    @user = User.new(login: params[:login],
                     password: params[:password] )

    if current_user&.admin
      @user.admin = params[:admin]
    else
      @user.admin = false
    end
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user
      if current_user.admin || updating_yourself
        @user.login = params[:login]
        @user.password = params[:password]
        if current_user.admin
          @user.admin = params[:admin]
        end
        if @user.save
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      else
        head(:unauthorized)
      end
    else
      head(:not_found)
    end
  end
end
