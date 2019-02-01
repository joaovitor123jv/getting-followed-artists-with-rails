class ApiController < ApplicationController
	def ping
		response = {}
		response[:status] = 200
		response[:response] = 'API WORKING'
		render json: response.to_json, status: 200
	end
end
