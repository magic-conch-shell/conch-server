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

  def set_headers
    if request.headers["HTTP_ORIGIN"]
    # better way check origin
    # if request.headers["HTTP_ORIGIN"] && /^https?:\/\/(.*)\.some\.site\.com$/i.match(request.headers["HTTP_ORIGIN"])
      headers['Access-Control-Allow-Origin'] = request.headers["HTTP_ORIGIN"]
      headers['Access-Control-Expose-Headers'] = 'ETag'
      headers['Access-Control-Allow-Methods'] = 'GET, POST, PATCH, PUT, DELETE, OPTIONS, HEAD'
      headers['Access-Control-Allow-Headers'] = '*,X-Requested-With,Content-Type,If-Modified-Since,If-None-Match,Auth-User-Token'
      headers['Access-Control-Max-Age'] = '86400'
      headers['Access-Control-Allow-Credentials'] = 'true'
    end
    headers['Access-Control-Allow-Credentials'] = 'true'
  end
  helper_method :set_headers
end
