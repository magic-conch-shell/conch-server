class Api::UsersController < ApplicationController
  before_filter :authorize
  respond_to :json

  def show
  end

  def update
  end

  def destroy
  end
end
