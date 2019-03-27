class Api::UsersController < ApplicationController
  before_action :authorize
  skip_before_action :verify_authenticity_token

  def show
    if @user = User.find(params[:id])
      render :json => @user
    else
      render :json => nil
    end
  end

  def update
    if @user = User.find(params[:id])
      @user.update_column(:is_mentor, params[:is_mentor])
      render :json => @user
    else
      render :json => nil
    end
  end

  def destroy
  end
end
