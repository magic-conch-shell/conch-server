class Api::RatingsController < ApplicationController
  before_action :authorize
  skip_before_action :verify_authenticity_token

  def index
    @answer = Answer.find(params[:answer_id])
    @question = Question.find(@answer.question_id)

    if current_user.id == @question.user_id || current_user.id == @answer.user_id
      if (@rating = Rating.where(answer_id: @answer.id).first)
        render :json => @rating, status: 200
      else
        render :json => {
          error: 'Failed to retrieve rating data from the server',
          status: 500
        }, status: 500
      end
    else
      render :json => {
        error: 'Unrelated user to access the rating',
        status: 403
      }, status: 403
    end
  end

  def create
    @answer = Answer.find(params[:answer_id])
    @question = Question.find(@answer.question_id)
    r_value = params[:value].to_i
    if @question && current_user.id == @question.user_id && r_value >= 0 && r_value <= 10
      @rating = @answer.ratings.new(
        value: params[:value],
        user_id: @answer.user_id
      )

      if @rating.save
        render :json => @rating, status: 201
      else
        render :json => {
          error: 'Failed to save rating data from the server',
          status: 500
        }, status: 500
      end
    else
      render :json => {
        error: 'Unrelated user to create the rating/value out of range',
        status: 403
      }, status: 403
    end
  end
end
