require 'test_helper'

class ApiControllerTest < ActionDispatch::IntegrationTest
  def default

  end

  test "get ping should return ok" do
    get '/api/v1/ping'
    response = JSON.parse(@response.body)
    assert_equal 200, response['status']
    assert_equal "API WORKING", response['data']
    assert_response :success
  end

  test "get /api/v1/authorize-spotify should redirect to url" do
    get '/api/v1/authorize-spotify'
    assert_response :redirect
    assert_match /https:\/\/accounts.spotify.com\/authorize/, @response.redirect_url
  end

  test "get to /api/v1/callback should redirect to localhost:3000/artist-list" do
    get '/api/v1/callback', params: {
      code: 'lakajksdjksdlajkd',
      access_token: 'kaspdoksodpps'
    }
    assert_response :redirect
    assert_match /http:\/\/localhost:3000/, @response.redirect_url
  end

  test "get to /api/v1/get-user-artists should return artist list with correct params" do
    @user = users(:user1)
    @artist1 = artists(:artist1)
    @artist2 = artists(:artist2)
    @artist3 = artists(:artist3)
    assert UserArtistConnection.create(user_id: @user.id, artist_id: @artist1.id)
    assert UserArtistConnection.create(user_id: @user.id, artist_id: @artist2.id)
    assert UserArtistConnection.create(user_id: @user.id, artist_id: @artist3.id)
    @user.api_access_token = 'asdfghjklzxcvbnm'
    assert @user.save

    get '/api/v1/get-user-artists', params: {
      uid: @user.uid,
      api_access_token: @user.api_access_token
    }
    assert_response :success

    response = JSON.parse(@response.body)

    assert_equal 200, response['status']
    assert_equal @artist1.name, response['data'][0]['name']
    assert_equal @artist2.name, response['data'][1]['name']
    assert_equal @artist3.name, response['data'][2]['name']
    assert_equal @artist1.followers_number, response['data'][0]['followers_number']
    assert_equal @artist2.followers_number, response['data'][1]['followers_number']
    assert_equal @artist3.followers_number, response['data'][2]['followers_number']

  end


  test "get to /api/v1/get-user-artists should return specific error with wrong api_access_token" do
    @user = users(:user1)
    @artist1 = artists(:artist1)
    @artist2 = artists(:artist2)
    @artist3 = artists(:artist3)
    assert UserArtistConnection.create(user_id: @user.id, artist_id: @artist1.id)
    assert UserArtistConnection.create(user_id: @user.id, artist_id: @artist2.id)
    assert UserArtistConnection.create(user_id: @user.id, artist_id: @artist3.id)
    @user.api_access_token = 'asdfghjklzxcvbnm'
    assert @user.save

    get '/api/v1/get-user-artists', params: {
      uid: @user.uid,
      api_access_token: 'anything_here'
    }
    assert_response 401

    response = JSON.parse(@response.body)

    assert_equal 401, response['status']
    assert_equal true, response['data']['error']
    assert_equal "INVALID ACCESS_TOKEN", response['data']['extra_info']

  end

  test "get to /api/v1/get-user-artists should return specific error with wrong uid" do
    @user = users(:user1)
    @artist1 = artists(:artist1)
    @artist2 = artists(:artist2)
    @artist3 = artists(:artist3)
    assert UserArtistConnection.create(user_id: @user.id, artist_id: @artist1.id)
    assert UserArtistConnection.create(user_id: @user.id, artist_id: @artist2.id)
    assert UserArtistConnection.create(user_id: @user.id, artist_id: @artist3.id)
    @user.api_access_token = 'asdfghjklzxcvbnm'
    assert @user.save

    get '/api/v1/get-user-artists', params: {
      uid: 'anoiq09ve90js90das09',
      api_access_token: @user.api_access_token
    }
    assert_response 401

    response = JSON.parse(@response.body)

    assert_equal 401, response['status']
    assert_equal true, response['data']['error']
    assert_match /Can\'t find an user with this \'uid\': /, response['data']['extra_info']
  end


  # test "get authorize spotify should return ok" do
  #   get '/api/v1/authorize-spotify'
  #   response = JSON.parse(@response.body)
  #   assert_response :success
  #   puts "Retorno = #{response}"
  # end

end
