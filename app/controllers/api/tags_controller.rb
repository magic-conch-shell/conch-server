class Api::TagsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render :json => Tag.all, status: 200
  end

  def create
  end

  def show
  end

  def destroy
  end
end
