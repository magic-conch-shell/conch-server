class Api::AnswersController < ApplicationController
  before_action :authorize
  skip_before_action :verify_authenticity_token

  def index
    if (@answers = Answer.where(user_id: params[:user_id])) && current_user.id == params[:user_id].to_i
      render :json => @answers
    else
      render :json => nil
    end
  end

  def create
    @question = Question.find(params[:question_id])
    @mentor_tags = UserTag.where(user_id: current_user.id).map { |x| x.tag_id }
    @question_tags = QuestionTag.where(question_id: params[:question_id]).map { |x| x.tag_id }
    matches = @mentor_tags & @question_tags
    if @question && current_user.is_mentor && current_user.id != @question.user_id && matches.size > 0
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
    if current_user.id == @answer.user_id || current_user.id == @question.user_id
      render :json => @answer
    else
      render :json => nil
    end
  end

  def update
    @answer = Answer.find(params[:id])
    @question = Question.find(@answer.question_id)
    if current_user.id == @question.user_id
      @answer.update_column(:selected, params[:selected])
      if params[:selected] == 'true'
        @question.update_column(:solved, true)
      else
        @question.update_column(:solved, false)
      end
      render :json => true
    else
      render :json => false
    end
  end

  def destroy
  end
end
