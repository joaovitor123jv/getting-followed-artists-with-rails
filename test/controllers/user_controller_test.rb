require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest
  test "should redirect user show" do
    get user_show_url
    follow_redirect!
    assert_response :found
  end

  test "should redirect user artist_index" do
    get user_artist_index_url
    follow_redirect!
    assert_response :found
  end

end
