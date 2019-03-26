require 'test_helper'

class Api::RatingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_ratings_index_url
    assert_response :success
  end

  test "should get create" do
    get api_ratings_create_url
    assert_response :success
  end

end
