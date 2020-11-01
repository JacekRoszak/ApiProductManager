class UsersController < ApplicationController

  def updating_yourself
    User.find_by(authentication_token: params[:authentication_token]) == User.find(params[:id])
  end

  def index
    @users = params[:login] ? User.where(login: params[:login]) : User.all
    render json: @users
  end

  def create
    if current_user.admin
      @user = User.new(login: params[:login],
                       password: BCrypt::Password.create(params[:password]),
                       admin: params[:admin] )
      if @user.save
        render json: @user, status: :created, location: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    if current_user.admin || updating_yourself
      @user = User.find_by(login: params[:login])
      @user.password = params[:password]
      @user.admin = params[:admin] if current_user.admin
      if @user.save
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      head(:unauthorized)
    end
  end
end
