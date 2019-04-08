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
      tag_list.each do |tagid|
        if Tag.find(tagid)
          @new_user_tag = current_user.user_tags.new(tag_id: tagid)
          unless @new_user_tag.save
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
    if current_user.is_mentor
      tagid = params[:id]
      if Tag.find(tagid)
        @user_tag = current_user.user_tags.where(tag_id: tagid)
        p @user_tag
        if @user_tag
          unless @user_tag.destroy_all
            return render :json => true, status: 200
          end
        else
          return render :json => {
            error: 'Failed to delete tag from user',
            status: 500
          }, status: 500
        end
      end
    else
      render :json => {
        error: 'User is not a mentor',
        status: 403
      }, status: 403
    end
  end
end
