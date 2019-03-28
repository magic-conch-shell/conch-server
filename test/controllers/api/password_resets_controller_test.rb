require 'test_helper'

class Api::PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_password_resets_create_url
    assert_response :success
  end

  test "should get update" do
    get api_password_resets_update_url
    assert_response :success
  end

end
