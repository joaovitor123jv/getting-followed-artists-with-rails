module UserHelper
	include UsefulUrlsHelper

	#
	# Fetches Spotify and get followed artists of the user passed
	#
	# @param [Hash] data Must be {user: user}, will search for artists of this user
	#
	# @return [Hash] The JSON parse of Spotify Response
	#
	def get_user_artists_from_spotify(data)
		base_url = get_api_url_for('/v1/me/following?type=artist')

		params = { access_token: data[:user].access_token }

		begin
			response = RestClient.get( base_url , { params: params })
			artists = JSON.parse(response.body)['artists']
			return artists
			
		rescue RestClient::ExceptionWithResponse => e
			puts "ERROR: FAILED TO FETCH SPOTIFY ARTISTS"
			return nil

		end
	end

	#
	# Gets the Artists vinculated with this User, from database only
	#
	# @param [User] user Will search artists of this user
	#
	# @return [Artists[]] An array of artists that are vinculated to this user
	#
	def get_user_artists_from_database(user)
		return nil if user.nil?
		return user.artists.all
	end

	#
	# Returns the user Artists, toggle from spotify to database automatically
	#
	# @param [User] user The artist array will be associated with this user
	#
	# @return [Artist[]] An Array of Artist, containing the artists followed by the user
	#
	def get_user_artists(user)
		from_database = false
		artists = get_user_artists_from_spotify(user: user)

		if artists.nil?
			if user_has_artists?(user)
				artists = get_user_artists_from_database(user)
				from_database = true
			else
				return nil
			end
		end

		if not from_database
			if not Artist.store(artists)
				if user_has_artists?(user)
					artists = get_user_artists_from_database(user)
					from_database = true
				else
					return nil
				end
			end

			if not from_database
				artists_ids = extract_artists_ids(artists)

				if not UserArtistConnection.connect_user_to({user: user, artists: artists_ids})
					if not user_has_artists?(user)
						return nil
					else
						artists = get_user_artists_from_database(user)
						from_database = true
					end
				end
			end
		end
		if from_database
			return artists
		else
			get_user_artists_from_database(user)
		end
	end


	#
	# Returns true if the User hava any artist linked on database
	#
	# @param [User] user The user to be tested
	#
	# @return [Boolean] True if the user have artists stored in database, false otherwise
	#
	def user_has_artists?(user)
		return true if UserArtistConnection.find_by(user_id: user.id)
		return false
	end
end
