class Api::JoinQueueController < ApplicationController
  before_action :authorize
  skip_before_action :verify_authenticity_token

  def create
    if current_user.is_mentor
      if current_user.mentor_status
        unless current_user.mentor_status.destroy!
          return render :json => {
            error: 'Server failed to remove mentor from the queue',
            status: 500
          }, status: 500
        end
      else
        create_mstatus
      end
      render :json => true, status: 200
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
          channel: "user-" + "#{current_user.id}",
          message: { STATUS: 'MATCHED', question_id: question.question_id }
        )
        $pubnub.publish(
          channel: "user-" + "#{quid}",
          message: { STATUS: 'ACCEPTED', question_id: question.question_id }
        )
        return
      end
    end
  end
end
