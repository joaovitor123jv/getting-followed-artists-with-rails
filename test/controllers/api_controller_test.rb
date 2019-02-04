require 'test_helper'

class ApiControllerTest < ActionDispatch::IntegrationTest
  def default
    enable_omniauth_test_mode

  end

  test "get ping should return ok" do
    get '/api/v1/ping'
    response = JSON.parse(@response.body)
    assert_equal 200, response['status']
    assert_equal "API WORKING", response['data']
    assert_response :success
  end

  # test "get authorize spotify should return ok" do
  #   get '/api/v1/authorize-spotify'
  #   response = JSON.parse(@response.body)
  #   assert_response :success
  #   puts "Retorno = #{response}"
  # end

end
