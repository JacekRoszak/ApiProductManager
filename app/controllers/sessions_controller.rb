class SessionsController < ApplicationController
  skip_before_action :authenticate_with_token, only: :create
  
  def create
    user = User.find_by(login: params[:login])
    if user&.authenticate(params[:password])
      render json: { authentication_token: user.authentication_token}, status: :created
    else
      head(:unauthorized)
    end
  end
end
