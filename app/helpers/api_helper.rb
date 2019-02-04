module ApiHelper
	include UsefulUrlsHelper

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
