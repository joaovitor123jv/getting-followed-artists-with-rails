#
# API CALLS routes  '/api/v1/*'
#
class ApiController < ApplicationController
	include ApplicationHelper
	include ApiHelper
	include UserHelper

	protect_from_forgery unless: -> { request.format.json? }
	before_action :validate_user, only: [:get_artist_list]


	def ping
		response = {}
		response[:status] = 200
		response[:data] = 'API WORKING'
		render json: response.to_json, status: 200
	end

	def authorize_spotify
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

	def get_artist_list
		if @error_report[:data][:error]
			# puts "AN ERROR WAS DETECTED, RETURNING ERROR LOG"
			# puts "ERROR == #{@error_report[:data][:extra_info]}"
			return render json: @error_report.to_json, status: @error_report[:status]
		end

		artists = get_user_artists(@user)
		if not artists
			return render json: @error_report.to_json, status: @error_report[:status]
		end

		artistList = { status: 200, data: [] }

		artists.each do |artist|
			artistList[:data] << {
				name: artist.name,
				followers_number: artist.followers_number
			}
		end
		# puts "Returning: ====="
		# pp artistList

		return render json: artistList.to_json, status: 200
	end

	private
		def validate_user
			@error_report = {
				status: 401,
				data: {
					error: true
				}
			}
			if params['uid'].nil? or params['api_access_token'].nil?
				# puts "NIL ARGUMENTS, RETURNING NIL"
				@error_report[:data][:extra_info] = "Missing 'uid' and 'api_access_token'"
				return @error_report
			end

			# puts "RECEIVED PARAMS: ================"
			# pp params.to_json
			# puts "================ END ================"

			user = User.find_by(uid: params['uid'])
			if user.nil?
				@error_report[:data][:extra_info] = "Can't find an user with this 'uid': #{params['uid']}"
				return @error_report
			end

			if user.api_access_token == params['api_access_token']
				# puts "VALID USER, ACCESSING API FUNCTION"
				@error_report[:data][:error] = false
				@error_report[:status] = 200
				@user = user
				return @error_report

			else
				# puts "INVALID ACCESS_TOKEN, RETURNING UNAUTHORIZED STATUS"
				@error_report[:data][:extra_info] = "INVALID ACCESS_TOKEN"
				return @error_report

			end
		end

end
