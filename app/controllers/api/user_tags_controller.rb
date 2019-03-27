class Api::UserTagsController < ApplicationController
  before_action :authorize
  skip_before_action :verify_authenticity_token

  def index
    if current_user.is_mentor && (@user_tags = UserTag.where(user_id: current_user.id))
      @tags = []
      @user_tags.each do |utag|
        tag = Tag.find(utag.tag_id)
        @tags << tag
      end

      render :json => @tags, status: 200
    else
      render :json => {
        error: 'User is not a mentor',
        status: 403
      }, status: 403
    end
  end

  def create
    if current_user.is_mentor
      tag_list = params[:tags]
      tag_list.each do |tag_name|
        found_tag = Tag.where(name: tag_name)
        if found_tag.size > 0
          t_id = found_tag.first.id
          @new_user_tag = current_user.user_tags.new(tag_id: t_id)
          if !@new_user_tag.save
            return render :json => {
              error: 'Failed to save tags data from the server',
              status: 500
            }, status: 500
          end
        end
      end

      render :json => UserTag.where(user_id: current_user.id), status: 201
    else
      render :json => {
        error: 'User is not a mentor',
        status: 403
      }, status: 403
    end
  end

  def destroy
  end
end
