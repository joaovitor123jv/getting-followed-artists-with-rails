class UserArtistConnection < ApplicationRecord
	has_many :artists
	has_many :users
	validates :user_id, presence: true
	validates :artist_id, presence: true

	#
	# Creates a connection between User and Artist
	#
	# @param [User] .make_connectionuser The user to be connected to Artist
	# @param [Artist] artist The artist to be connected to User
	#
	# @return [Boolean] True on succes, false otherwise
	#
	def UserArtistConnection.make_connection(user, artist)
		return false if user.nil? or artist.nil?
		connection = find_or_create_by(user_id: user.id, artist_id: artist.id)
		return false if connection.nil?
		return true
	end

	#
	# Connect a specific user to one artist or more. Send {artist: Artist.find(...)} to connect one, and {artists: Artist.where(...)} to connect more
	#
	# @param [Hash] .connect_user_toconnections In format {user: User, (artist: Artist) || (artists: Artist[])}
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
