require 'test_helper'

class Api::Users::QuestionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_users_questions_index_url
    assert_response :success
  end

end
