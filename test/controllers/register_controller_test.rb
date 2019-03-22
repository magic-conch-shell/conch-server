require 'test_helper'

class RegisterControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get register_create_url
    assert_response :success
  end

end
