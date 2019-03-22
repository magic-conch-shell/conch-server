require 'test_helper'

class Api::Users::AnswersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_users_answers_index_url
    assert_response :success
  end

end
