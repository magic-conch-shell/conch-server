class Api::UserTagsController < ApplicationController
  before_action :authorize
  skip_before_action :verify_authenticity_token

  def index
    if (@user_tags = User_Tag.where(user_id: current_user.id))
      render :json => @user_tags
    else
      render :json => nil
    end
  end

  def create
    if current_user.is_mentor
      tag_list = params[:tags]
      tag_list.each do |tag_name|
        t_id = Tag.where(name: tag_name).first.id
        @new_user_tag = current_user.user_tags.new(tag_id: t_id)
        if !@new_user_tag.save
          return render :json => nil
        end
      end

      render :json => User_Tag.where(user_id: current_user.id)
    else
      render :json => nil
    end
  end

  def destroy
  end
end
