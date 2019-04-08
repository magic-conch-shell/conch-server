class Api::Users::QuestionsController < ApplicationController
  before_action :authorize
  respond_to :json
  before_action :set_headers
  #not used
  def index
  end
end
