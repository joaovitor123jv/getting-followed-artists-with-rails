class ApiController < ApplicationController
	include ApiHelper
	protect_from_forgery unless: -> { request.format.json? }


	def ping
		response = {}
		response[:status] = 200
		response[:data] = 'API WORKING'
		render json: response.to_json, status: 200
	end

	def authorize_spotify
		response = {}
		response[:status] = 200
		response[:data] = 'API WORKING'
		@response = get_spotify_token_url()
		return redirect_to @response
	end

	def callback
		error_url = get_frontent_url_for(generate_get_param(authorized: false))

		data = get_access_data_from_spotify(params['code'])
		return redirect_to error_url if data.nil?

		user_info = get_user_information(data['access_token'])
		return redirect_to error_url if user_info.nil?

		user = User.update_user_data({
			uid: user_info['id'], 
			name: user_info['display_name'],
			access_token: data['access_token'],
			refresh_token: data['refresh_token']
		})
		return redirect_to error_url if user.nil?

		full_url = get_frontent_url_for('/artist-list?')
		full_url += generate_get_param(authorized: true)
		full_url += generate_get_param(name: user.name)
		full_url += generate_get_param(uid: user.uid)
		full_url += generate_get_param(api_access_token: user.api_access_token)

		return redirect_to full_url
	end

end
