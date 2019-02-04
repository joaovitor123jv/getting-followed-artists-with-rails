require 'test_helper'

class UserArtistConnectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should not save user-artist connection withouth artist" do
    connection = UserArtistConnection.new(user_id: 123)
    assert_not connection.save
  end

  test "should not save user-artist connection withouth user" do
    connection = UserArtistConnection.new(artist_id: 123)
    assert_not connection.save
  end

  test "should create connection if all data is specified" do
    connection = UserArtistConnection.new

    user = User.create({ name: 'Some User', uid: 'oqoq', access_token: '123123123123123213' })

    artist = Artist.create({
      name: 'Some Artist',
      uid: 'aiaiaiaiai',
      spotify_url: 'https://spotify.com/something_here'
    })

    connection.user_id = user.id
    connection.artist_id = artist.id
    assert connection.save
  end

  test 'should not create connections with invalid ids' do
    connection = UserArtistConnection.new
    connection.user_id = 1
    connection.artist_id = 1
    assert_not connection.save
  end
end
