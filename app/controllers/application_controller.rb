class ApplicationController < ActionController::API
  before_action :authenticate_with_token

  def current_user
    @current_user ||= User.find_by(authentication_token: params[:authentication_token])
  end

  def authenticate_with_token
    user = User.exists?(authentication_token: params[:authentication_token])
    return head(:unauthorized) unless user
  end
end
