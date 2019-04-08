class Api::UsersController < ApplicationController
  before_action :authorize
  skip_before_action :verify_authenticity_token

  def show
    if @user = User.find(params[:id])
      render :json => @user, :methods => :tags, status: 200
    else
      render :json => {
        error: 'No user found with matching ID',
        status: 400
      }, status: 400
    end
  end

  def update
    if @user = User.find(params[:id])
      if params[:is_mentor]
        @user.update_column(:is_mentor, params[:is_mentor])
        render :json => @user, status: 200
      elsif params[:nickname]
        @user.update_column(:nickname, params[:is_mentor])
        render :json => @user, status: 200
      elsif params[:avatar]
        @user.profile_picture.purge
        @user.profile_picture.attach(params[:avatar])
        render :json => @user, status: 200
      end
    else
      render :json => {
        error: 'No user found with matching ID',
        status: 400
      }, status: 400
    end
  end

  def destroy
  end
end
