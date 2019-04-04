require 'test_helper'

class Api::JoinQueueControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_join_queue_create_url
    assert_response :success
  end

end
