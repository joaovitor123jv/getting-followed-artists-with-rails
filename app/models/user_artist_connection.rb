class UserArtistConnection < ApplicationRecord
	belongs_to :artist
	belongs_to :user

	validates :user_id, presence: true
	validates :artist_id, presence: true

	#
	# Creates a connection between User and Artist
	#
	# @param [User] user The user to be connected to Artist
	# @param [Artist] artist The artist to be connected to User
	#
	# @return [Boolean] True on succes, false otherwise
	#
	def UserArtistConnection.make_connection(user, artist)
		return false if user.nil? or artist.nil?

		if not user.user_artist_connections.find_or_create_by(artist: artist)
			puts "FAILED TO CREATE CONNECTION"
			return false
		end
		return true
	end

	#
	# Connect a specific user to one artist or more. Send {artist: Artist.find(...)} to connect one, and {artists: Artist.where(...)} to connect more
	#
	# @param [Hash] connections In format {user: User, (artist: Artist) || (artists: Artist[])}
	#
	# @return [Boolean] True on succes, false otherwise
	#
	def UserArtistConnection.connect_user_to(connections)
		user = connections[:user]
		if connections[:artist].nil?
			connections[:artists].each do |artist_id|
				artist = Artist.find_by(uid: artist_id)
				if not make_connection(user, artist)
					return false
				end
			end
		else
			artist = Artist.find_by(uid: connections[:artist])
			if not make_connection(user, artist)
				return false
			end
		end
		return true
	end
end
