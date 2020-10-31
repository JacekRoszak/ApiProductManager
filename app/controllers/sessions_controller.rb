class SessionsController < ApplicationController
  def create
    user = User.find_by(login: params[:login])
    
    if user
      auth = user.authenticate(params[:password])
      if auth
        session[:current_user_id] = auth.id
        render :create, status: :created
      else
        head(:unauthorized)
      end
    else
      head(:unauthorized)
    end
  end

  def destroy
    current_user&.authentication_token = nil
    if current_user&.save
      head(:ok)
    else
      head(:unauthorized)
    end
  end

end
