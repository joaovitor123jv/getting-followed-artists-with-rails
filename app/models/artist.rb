class Artist < ApplicationRecord
	# belongs_to :user
	# belongs_to :user_artist_connections
	validates :uid, presence: true, uniqueness: true
	validates :spotify_url, uniqueness: true

	# validates :user_id, presence: true

	#
	# Stores or updates the artists fetched from Spotify
	#
	# @param [Hash] .storespotify_artists Hash containing the artist data from spotify
	#
	# @return [Boolean] False if cant save something, true if succeed
	#
	def Artist.store(spotify_artists)
		pp spotify_artists
		spotify_artists['items'].each do |artist|
			db_artist = find_or_create_by(uid: artist['id'])
			db_artist.name = artist['name']
			db_artist.followers_number = artist['followers']['total']
			db_artist.spotify_url = artist['external_urls']['spotify']
			if not db_artist.save!
				return false
			end
		end
	end

end

