class Api::Users::QuestionsController < ApplicationController
  before_filter :authorize
  respond_to :json

  def index
  end
end
