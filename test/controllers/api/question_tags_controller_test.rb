require 'test_helper'

class Api::QuestionTagsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_question_tags_index_url
    assert_response :success
  end

end
