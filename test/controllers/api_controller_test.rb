require 'test_helper'

class ApiControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "get ping should return ok" do
    get '/api/ping'
    response = JSON.parse(@response.body)
    assert_equal 200, response['status']
    assert_equal "API WORKING", response['response']
    assert_response :success
  end
end
