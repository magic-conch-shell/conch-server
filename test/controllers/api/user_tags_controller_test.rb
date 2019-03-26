require 'test_helper'

class Api::UserTagsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_user_tags_index_url
    assert_response :success
  end

  test "should get create" do
    get api_user_tags_create_url
    assert_response :success
  end

  test "should get destroy" do
    get api_user_tags_destroy_url
    assert_response :success
  end

end
