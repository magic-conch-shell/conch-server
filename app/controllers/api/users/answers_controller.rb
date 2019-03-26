class Api::Users::AnswersController < ApplicationController
  before_action :authorize
  respond_to :json
  # not used
  def index
  end
end
