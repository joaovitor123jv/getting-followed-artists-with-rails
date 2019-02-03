module ApiHelper
	#
	# Generates a URL to Spotify API
	#
	# @param [path] path The api path (uri)
	#
	# @return [String] The full URL
	#
	def get_api_url_for(path)
		base_url = 'https://api.spotify.com'
		return (base_url << path)
	end

	#
	# Generates an GET param from a hash
	#
	# @param [Hash] item Hash containing a key and a value
	#
	# @return [String] param Formatted to use in GET requisitions
	# 
	# @example generate_get_param(uid: 'something') ==> "&uid=something"
	#
	def generate_get_param(item)
		item.each do |key, value|
			puts "KEY = #{key}"
			puts "VALUE = #{value}"
			puts "==========="
			return '&'<<key.to_s<<'='<<value.to_s
		end
	end

	#
	# Returns the front-end app URL (created using React)
	#
	# @param [String] path URI and/or params to send via GET
	#
	# @return [String] The generated String
	#
	def get_frontent_url_for(path)
		return "http://localhost:3000/#{path}"
	end

	#
	# Gets data containing 'access_token' from Spotify API
	#
	# @param [String] code Code obtained in spotify request params
	#
	# @return [Hash] Hash with 'access_token', 'refresh_token', 'expires_in' and other stuff. Nil if Forbidden
	#
	def get_access_data_from_spotify(code)
		full_url = get_spotify_account_service_url_for('/api/token')

		begin
			response = RestClient.post(full_url, {
				code: code,
				redirect_uri: 'http://localhost:8000/api/v1/callback',
				grant_type: "authorization_code",
				client_id: ENV['SPOTIFY_KEY'],
				client_secret: ENV['SPOTIFY_SECRET']
			})
			data = JSON.parse response.body

			# if the user doesn't authorized access, return error
			return nil if (data['state'] == 123)
			return data

		rescue RestClient::ExceptionWithResponse => e
			return nil

		end
	end

	#
	# Generate a URL to accounts.spotify.com
	#
	# @param [String] service Path to service, as '/authorize'
	#
	# @return [String] The generated URL
	#
	def get_spotify_account_service_url_for(service)
		return "https://accounts.spotify.com#{service}"
	end

	#
	# Get URL to get USER Code from Spotify, to use in (spotify_url.../authorize) in callback
	#
	# @return [String] User connection Token
	#
	def get_spotify_token_url()
		full_url = get_spotify_account_service_url_for('/authorize') << '?'
		full_url += generate_get_param(client_id: ENV['SPOTIFY_KEY'])
		full_url += generate_get_param(redirect_uri: 'http://localhost:8000/api/v1/callback')
		full_url += generate_get_param(response_type: 'code')
		full_url += generate_get_param(scope: ENV['SPOTIFY_SCOPE'])
		return full_url
	end

	#
	# Returns user info, fetched from Spotify API
	#
	# @param [String] access_token Access_token, obtained from spotify '/authorize'
	#
	# @return [Hash] Contains user info with 'access_token', 'token_type', 'refresh_token', 
	#    'scope' and 'expires_in'
	#
	def get_user_information(access_token)
		full_url = get_api_url_for('/v1/me')
		response = nil
		begin
			response = RestClient.get(full_url, {
				'Authorization': ('Bearer ' << access_token)
			})
			puts "======== RECEIVED RESPONSE - GET USER INFORMATION ===="
			pp response.body
			puts "======== END ========"
			return JSON.parse response.body

		rescue RestClient::ExceptionWithResponse => e
			puts "EXCEPTION"
			pp e.response.body
			return { error: true }
		end
	end
end
