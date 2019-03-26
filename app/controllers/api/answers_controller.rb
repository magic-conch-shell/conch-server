class Api::AnswersController < ApplicationController
  before_action :authorize
  respond_to :json

  def index
    if (@answers = Answer.where(user_id: params[:user_id]))
      render :json => @answers
    else
      render :json => nil
    end
  end

  def create
    @question = Question.find(params[:question_id])
    if @question && current_user.is_mentor
      @answer = @question.answers.new(
        user_id: current_user.id,
        content: params[:content],
        selected: false
      )
      if @answer.save
        render :json => @answer
      else
        render :json => nil
      end
    else
      render :json => nil
    end
  end

  def show
    @answer = Answer.find(params[:id])
    @question = Question.find(@answer.question_id)
    if current_user.id == @answer.user_id || current_user == @question.user_id
      render :json => @answer
    else
      render :json => nil
    end
  end

  def update
    @answer = Answer.find(params[:id])
    @question = Question.find(@answer.question_id)
    if current_user == @question.user_id
      @answer.update_column(:selected, params[:selected])
      render :json => true
    else
      render :json => false
    end
  end

  def destroy
  end
end
