require 'test_helper'

class Api::VerifyTokenControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_verify_token_create_url
    assert_response :success
  end

end
