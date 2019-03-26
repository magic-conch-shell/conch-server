class Api::Users::QuestionsController < ApplicationController
  before_action :authorize
  respond_to :json
  #not used
  def index
  end
end
