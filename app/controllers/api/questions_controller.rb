class Api::QuestionsController < ApplicationController
  before_action :authorize
  skip_before_action :verify_authenticity_token

  def index
    if (@questions = Question.where(user_id: params[:user_id]))
      render :json => @questions
    else
      render :json => nil
    end
  end

  def create
    tag_list = params[:tags]
    params = question_params
    @question = current_user.questions.new(params)
    @question[:solved] = false

    if @question.save
      create_qtag(@question, tag_list)

      render :json => @question
    else
      render :json => nil
    end
  end

  def show
    @question = Question.find(params[:id])
    if @question && @question.user_id == current_user.id
      render :json => @question
    else
      render :json => nil
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
