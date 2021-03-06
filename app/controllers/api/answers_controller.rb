class Api::AnswersController < ApplicationController
  before_action :authorize
  skip_before_action :verify_authenticity_token
  before_action :set_headers

  def index
    if params[:user_id]
      if (@answers = Answer.order('created_at ASC').where(user_id: params[:user_id])) && current_user.id == params[:user_id].to_i
        render :json => @answers, status: 200
      else
        render :json => {
          error: 'User is not a mentor with access to this answer',
          status: 403
        }, status: 403
      end
    else
      @answers = Answer.order('created_at ASC').where(question_id: params[:question_id])
      auid = @answers.map { |x| x.user_id }
      matches = auid & [current_user.id]
      if @answers && (current_user.id == Question.find(params[:question_id]).user_id || matches.size > 0)
        render :json => @answers, status: 200
      else
        render :json => {
          error: 'User is not authorized to access this answer',
          status: 403
        }, status: 403
      end
    end
  end

  def create
    @question = Question.find(params[:question_id])
    @mentor_tags = UserTag.where(user_id: current_user.id).map { |x| x.tag_id }
    @question_tags = QuestionTag.where(question_id: params[:question_id]).map { |x| x.tag_id }
    matches = @mentor_tags & @question_tags
    if @question && current_user.is_mentor && current_user.id != @question.user_id && matches.size > 0 && current_user.id == @question.question_status.mentor_id
      @answer = @question.answers.new(
        user_id: current_user.id,
        content: params[:content],
        selected: false
      )
      if @answer.save
        change_status(@question)
        render :json => @answer, status: 201
      else
        render :json => {
          error: 'Failed to save answer data from the server',
          status: 500
        }, status: 500
      end
    else
      render :json => {
        error: 'User is not a mentor, with matching tags, or in queue',
        status: 403
      }, status: 403
    end
  end

  def show
    @answer = Answer.find(params[:id])
    @question = Question.find(@answer.question_id)
    if current_user.id == @answer.user_id || current_user.id == @question.user_id
      render :json => @answer
    else
      render :json => {
        error: 'Unrelated user to access the answer data',
        status: 403
      }, status: 403
    end
  end

  def update
    @answer = Answer.find(params[:id])
    @question = Question.find(@answer.question_id)
    if current_user.id == @question.user_id
      @answer.update_column(:selected, params[:selected])
      qstatus = QuestionStatus.where(question_id: @question.id).first
      if params[:selected] == 'true'
        @question.update_column(:solved, true)

        qstatus.update_column(:status, 'RESOLVED')
        $pubnub.publish(
          channel: "user-" + "#{qstatus[:mentor_id]}" + "-client",
          message: { STATUS: 'RESOLVED', question_id: @question.id }
        )
        $pubnub.publish(
          channel: "user-" + "#{qstatus[:mentor_id]}" + "-mentor",
          message: { STATUS: 'SELECTED', question_id: @question.id }
        )
      else
        @question.update_column(:solved, false)

        qstatus.update_column(:status, 'SUBMITTED')
        check_match(@question)
        $pubnub.publish(
          channel: "user-" + "#{qstatus[:mentor_id]}" + "-mentor",
          message: { STATUS: 'PASSED', question_id: @question.id }
        )
      end
      render :json => @answer, status: 200
    else
      render :json => {
        error: 'User is not the owner of the question',
        status: 403
      }, status: 403
    end
  end

  def destroy
  end

  private

  def change_status(question)
    mstatus = MentorStatus.where(user_id: current_user.id).first
    qstatus = QuestionStatus.where(question_id: question.id).first

    qstatus.update_column(:status, 'ANSWERED')
    mstatus.update_column(:answering, false)

    $pubnub.publish(
      channel: "user-" + "#{question.user_id}" + "-client",
      message: { status: 'ANSWERED', question_id: question.id }
    )
    question.update_column(:is_dirty, true)

    tags = UserTag.where(user_id: current_user.id).map { |utag| utag.tag_id }
    qstatus = QuestionStatus.order('updated_at ASC').where(status: 'SUBMITTED')
    qstatus.each do |quest|
      qtagid = QuestionTag.where(question_id: quest.question_id).map { |x| x.tag_id }
      matches = qtagid & tags
      quid = Question.find(quest.question_id).user_id

      if matches.size > 0 && current_user.id != quid
        mstatus.update_column(:answering, true)
        quest.update_column(:status, 'ACCEPTED')
        quest.update_column(:mentor_id, mstatus.user_id)

        $pubnub.publish(
          channel: "user-" + "#{current_user.id}" + "-mentor",
          message: { status: 'ACCEPTED', question_id: quest.question_id }
        )
        $pubnub.publish(
          channel: "user-" + "#{quid}" + "-client",
          message: { status: 'ACCEPTED', question_id: quest.question_id }
        )
        Question.find(quest.question_id).update_column(:is_dirty, true)
        return
      end
    end
  end

  def check_match(question)
    tags = question.question_tags.map { |x| x.tag_id }
    mstatus = MentorStatus.order('updated_at ASC').where(answering: false)
    mstatus.each do |mentor|
      utagid = UserTag.where(user_id: mentor.user_id).map { |x| x.tag_id }
      matches = utagid & tags
      if matches.size > 0 && current_user.id != mentor.user_id
        mentor.update_column(:answering, true)
        qstatus.update_column(:status, 'ACCEPTED')
        qstatus.update_column(:mentor_id, mentor.user_id)

        $pubnub.publish(
          channel: "user-" + "#{current_user.id}" + "-client",
          message: { status: 'ACCEPTED', question_id: question.id }
        )
        $pubnub.publish(
          channel: "user-" + "#{mentor.user_id}" + "-mentor",
          message: { status: 'ACCEPTED', question_id: question.id }
        )
        return
      end
    end
  end
end
