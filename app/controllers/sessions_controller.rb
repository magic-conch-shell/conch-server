class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_headers

  def create
    if current_user
      render :json => current_user, :include => :mentor_status, :methods => [:tags, :avatar_url], status: 200
    else
      params = session_params

      if @user = User.authenticate_with_credentials(params[:email], params[:password])
        session[:user_id] = @user.id
        render :json => @user, :include => :mentor_status, :methods => [:tags, :avatar_url], status: 200
      else
        render :json => {
          error: 'Non-existing email, or incorrect password',
          status: 401
        }, status: 401
      end
    end
  end

  def destroy
    if current_user.mentor_status
      unless current_user.mentor_status.destroy!
        session[:user_id] = nil
        return render :json => {
          error: 'Server failed to remove mentor from the queue',
          status: 500
        }, status: 500
      end
    end
    uid = session[:user_id]
    session[:user_id] = nil
    render :json => uid, status: 204
  end

  private

  def session_params
    params.permit(
      :email,
      :password
    )
  end
end
