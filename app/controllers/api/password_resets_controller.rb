class Api::PasswordResetsController < ApplicationController
  def create
    @user = User.where(email: params[:email]).first

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      render :json => true, status: 200
    else
      render :json => {
        error: 'Email address not found',
        status: 403
      }, status: 403
    end
  end

  def update
  end
end
