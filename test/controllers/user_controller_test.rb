require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get user_show_url
    assert_response :success
  end

  test "should get artist_index" do
    get user_artist_index_url
    assert_response :success
  end

end
