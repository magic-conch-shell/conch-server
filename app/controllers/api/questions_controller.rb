class Api::QuestionsController < ApplicationController
  before_action :authorize
  skip_before_action :verify_authenticity_token

  def index
    if (@questions = Question.where(user_id: params[:user_id]))
      render :json => @questions, status: 200
    else
      render :json => {
        error: 'Failed to retrieve question data from the server',
        status: 500
      }, status: 500
    end
  end

  def create
    tag_list = params[:tags]
    if tag_list.size == 0
      return render :json => {
        error: 'At least one tag is required',
        status: 400
      }, status: 400
    end

    params = question_params
    @question = current_user.questions.new(params)
    @question[:solved] = false

    if @question.save
      create_qtag(@question, tag_list)

      render :json => @question, status: 201
    else
      render :json => {
        error: 'Failed to save question data from the server',
        status: 500
      }, status: 500
    end
  end

  def show
    @question = Question.find(params[:id])
    if @question && (@question.user_id == current_user.id || current_user.is_mentor)
      render :json => @question, status: 200
    else
      render :json => {
        error: 'Unrelated user to access question data',
        status: 403
      }, status: 403
    end
  end

  def destroy
  end

  private

  def question_params
    params.permit(
      :title,
      :content
    )
  end

  def create_qtag(question, tags)
    tags.each do |tag_name|
      t_id = Tag.where(name: tag_name).first.id
      question.question_tags.create!(tag_id: t_id)
    end
  end
end
