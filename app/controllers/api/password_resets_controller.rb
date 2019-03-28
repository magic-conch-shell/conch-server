class Api::PasswordResetsController < ApplicationController
  before_action :check_expiration, only: [:edit, :update]

  def create
    @user = User.where(email: params[:email]).first

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      render :json => true, status: 200
    else
      render :json => {
        error: 'Email address not found',
        status: 400
      }, status: 400
    end
  end

  def update
    @user = User.where(email: params[:email]).first
    if @user && @user.authenticated?(params[:token])
      if params[:password].size < 8
        return render :json => {
          error: 'Password must be at least 8 characters',
          status: 400
        }, status: 400
      elsif @user.update_attributes(password: params[:password])
        render :json => true, status: 200
      else
        render :json => {
          error: 'Server failed to update the password',
          status: 500
        }, status: 500
      end
    else
      render :json => {
        error: 'Not authorized to access password reset',
        status: 403
      }, status: 403
    end
  end

  private

  def check_expiration
    if @user.password_reset_expired?
      return render :json => {
        error: 'Reset token has been expired',
        status: 400
      }, status: 400
    end
  end
end
