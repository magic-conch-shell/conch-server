class Api::JoinQueueController < ApplicationController
  before_action :authorize
  skip_before_action :verify_authenticity_token
  before_action :set_headers

  def index
    if current_user.is_mentor
      if (@mstatus = current_user.mentor_status)
        if @mstatus.answering
          qid = QuestionStatus.where(status: 'ACCEPTED', mentor_id: current_user.id).first.question_id
          return render :json => {status: 'BUSY', question_id: qid}, status: 200
        else
          return render :json => {status: 'IN_QUEUE'}, status: 200
        end
      end
    end
    render :json => {status: 'NOT_IN_QUEUE'}, status: 200
  end

  def create
    if current_user.is_mentor
      if current_user.mentor_status
        unless current_user.mentor_status.destroy!
          return render :json => {
            error: 'Server failed to remove mentor from the queue',
            status: 500
          }, status: 500
        end
        render :json => {status: 'NOT_IN_QUEUE'}, status: 200
      else
        stat = create_mstatus
        render :json => stat, status: 200
      end
      # render :json => current_user.mentor_status, status: 200
    else
      render :json => {
        error: 'User is not a mentor',
        status: 403
      }, status: 403
    end
  end

  private

  def create_mstatus
    mstatus = MentorStatus.create!(user_id: current_user.id, answering: false)
    tags = UserTag.where(user_id: current_user.id).map { |utag| utag.tag_id }
    qstatus = QuestionStatus.order('updated_at ASC').where(status: 'SUBMITTED')
    qstatus.each do |question|
      qtagid = QuestionTag.where(question_id: question.question_id).map { |x| x.tag_id }
      matches = qtagid & tags
      quid = Question.find(question.question_id).user_id

      if matches.size > 0 && current_user.id != quid
        mstatus.update_column(:answering, true)
        question.update_column(:status, 'ACCEPTED')
        question.update_column(:mentor_id, mstatus.user_id)

        $pubnub.publish(
          channel: "user-" + "#{current_user.id}" + "-mentor",
          message: { status: 'ACCEPTED', question_id: question.question_id }
        )
        $pubnub.publish(
          channel: "user-" + "#{quid}" + "-client",
          message: { status: 'ACCEPTED', question_id: question.question_id }
        )
        return {status: 'BUSY', question_id: question.question_id}
      end
    end

    return {status: 'IN_QUEUE'}
  end
end
