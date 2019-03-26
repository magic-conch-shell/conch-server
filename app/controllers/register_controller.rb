class RegisterController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    session[:user_id] = nil
    @user = User.new(user_params)
    @user[:points] = 0
    @user[:is_mentor] = false

    if @user.save
      session[:user_id] = @user.id
      render :json => @user
    else
      render :json => Hash.new
    end
  end

  private

  def user_params
    params.permit(
      :nickname,
      :email,
      :password
    )
  end
end
