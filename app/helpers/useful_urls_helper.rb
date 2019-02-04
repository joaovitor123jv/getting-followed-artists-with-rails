module UsefulUrlsHelper
	#
	# Generates a URL to Spotify API
	#
	# @param [path] path The api path (uri)
	#
	# @return [String] The full URL
	#
	def get_api_url_for(path)
		return ('https://api.spotify.com' << path)
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
		return "http://localhost:3000#{path}"
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

end
