class ApplicationController < ActionController::Base
  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authorize
    unless current_user
      render :json => {
        error: 'Unauthorized access',
        status: 401
      }, status: 401
    end
  end
  helper_method :authorize
end
