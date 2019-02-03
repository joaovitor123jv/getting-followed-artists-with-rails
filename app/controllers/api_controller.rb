class ApiController < ApplicationController
	# protect_from_forgery with: :exception, unless: -> { request.format.json? }
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
		# render inline: "<%= response.body.html_content %>", status: 200

		return redirect_to @response

		# render html: @response.to_s.html_safe

	end

	def callback
		puts "CALLBACK CHAMADA !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		# puts "PARAMS == "
		# pp params

		# @response = {}
		# response[:status] = 200
		# response[:data] = 'API WORKING'
		puts "CODE == |#{params['code']}|"
		code = params['code']
		@response = {}

		full_url = get_spotify_account_service_url_for('/api/token')
		# full_url = URI(full_url)

		params = {
			code: code,
			redirect_uri: 'http://localhost:8000/api/v1/callback',
			grant_type: "authorization_code",
			client_id: ENV['SPOTIFY_KEY'],
			client_secret: ENV['SPOTIFY_SECRET']
		}

		begin
			response = RestClient.post(full_url, params)
			@response[:status] = 200
			data = JSON.parse response.body
			@response[:data] = data

			# Guardar no banco:
			#	data['access_token']
			#	data['refresh_token']
			#	data['expires_in']

			# Procurar por: ID DO USUARIO NO SPOTIFY   /v1/me

			pp response.body
		rescue RestClient::ExceptionWithResponse => e
			@response[:status] = 403
			@response[:data] = "FORBIDDEN"
			puts "DEU MERDA"
			pp e.response
			puts "=================="
			pp e.response.body

		end
		

		# response = Net::HTTP::Post.new(full_url, params).set_form_data(params)

		# puts "RESPONSE GOTTEN"
		# pp response.to_json

		# puts "RESPONSE CODE: #{response}"


		# render inline: "<%= response.body.html_content %>", status: 200

		render json: @response.to_json, status: @response[:status]
		# return redirect_to @response

	end

	private
		#
		# Generates a ull URL to Spotify API
		#
		# @param [path] path The api path (uri)
		#
		# @return [String] The full URL
		#
		def get_api_url_for(path)
			base_url = 'https://api.spotify.com'
			full_url = base_url << '/' << uri
		end

		def get_spotify_account_service_url_for(service)
			return "https://accounts.spotify.com#{service}"
		end

		#
		# Get USER Code from Spotify, for use in (spotify_url.../authorize) in callback
		#
		# @return [String] User connection Token
		#
		def get_spotify_token_url()
			full_url = get_spotify_account_service_url_for('/authorize') << '?'
			full_url += generateGetParam(client_id: ENV['SPOTIFY_KEY'])
			full_url += generateGetParam(redirect_uri: 'http://localhost:8000/api/v1/callback')
			full_url += generateGetParam(response_type: 'code')
			full_url += generateGetParam(scope: ENV['SPOTIFY_SCOPE'])

			puts "URL COMPLETA == |#{full_url}|"
			return full_url
		end

		def get_spotify_access_token_url(code)
			puts "TOKEN = |#{code}|"
			full_url = get_spotify_account_service_url_for('/api/token') << '?'
			full_url += generateGetParam(client_id: ENV['SPOTIFY_KEY'])
			full_url += generateGetParam(client_secret: ENV['SPOTIFY_SECRET'])
			full_url += generateGetParam(code: code)
			full_url += generateGetParam(redirect_uri: 'http://localhost:8000/api/v1/access_token')
			puts "FULL URL === |#{full_url}|"
			full_url
		end

		#
		# Generates an GET param from a hash
		#
		# @param [Hash] item Hash containing a key and a value
		#
		# @return [String] param formatted to use in GET requisitions
		#
		def generateGetParam(item)
			item.each do |key, value|
				puts "KEY = #{key}"
				puts "VALUE = #{value}"
				puts "==========="
				return '&'<<key.to_s<<'='<<value.to_s
			end
		end
end
