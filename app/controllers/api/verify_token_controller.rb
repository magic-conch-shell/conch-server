class Api::VerifyTokenController < ApplicationController
  def create
    @user = User.where(email: params[:email]).first
    if @user && @user.authenticated?(params[:token])
      render :json => true, status: 200
    else
      render :json => {
        error: 'Not authorized to access password reset form',
        status: 403
      }, status: 403
    end
  end
end
