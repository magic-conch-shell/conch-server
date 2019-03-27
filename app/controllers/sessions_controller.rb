class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    session[:user_id] = nil
    params = session_params

    if @user = User.authenticate_with_credentials(params[:email], params[:password])
      session[:user_id] = @user.id
      render :json => @user, status: 200
    else
      render :json => {
        error: 'Non-existing email, or incorrect password',
        status: 401
      }, status: 401
    end
  end

  def destroy
    session[:user_id] = nil
    render :json => nil, status: 204
  end

  private

  def session_params
    params.permit(
      :email,
      :password
    )
  end
end
