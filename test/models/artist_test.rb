require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'should not save artist withouth uid' do
    artist = Artist.new
    artist.spotify_url = 'sadkjasndjkasn'
    assert_not artist.save
  end

  test 'should not save artist withouth spotify_url' do
    artist = Artist.new
    artist.uid = 'sadkjasndjkasn'
    assert_not artist.save
  end

  test 'should save artist with spotify_url and uid' do
    artist = Artist.new
    artist.uid = 'sadkjasndjkasn'
    artist.spotify_url = 'https://spotify.com/some-pretty-url-here'
    assert artist.save
  end

  test 'should not save artist with duplicated spotify_url' do
    artist = Artist.new
    artist.uid = 'lskadjklasjdklas'
    artist.spotify_url = 'https://spotify.com/some-pretty-url'
    assert artist.save

    artist2 = Artist.new
    artist2.uid = 'kgr09jte90gj903jg0'
    artist2.spotify_url = artist.spotify_url
    assert_not artist2.save
  end

  test 'should not save artist with duplicated uid' do
    artist = Artist.new
    artist.uid = 'lskadjklasjdklas'
    artist.spotify_url = 'https://spotify.com/some-pretty-url'
    assert artist.save

    artist2 = Artist.new
    artist2.uid = artist.uid
    artist2.spotify_url = 'https://spotify.com/another-pretty-url'
    assert_not artist2.save
  end
end
