require 'test_helper'

class SessionControllerTest < ActionDispatch::IntegrationTest
    # test "should get create" do
  #   get session_create_url
  #   assert_response :success
  # end

  # test "should get destroy" do
  #   get session_destroy_url
  #   assert_response :success
  # end

  test "user can logout" do
    delete logout_url
    follow_redirect!
    assert_template 'static_pages/home'
    assert_response :success
  end

end
