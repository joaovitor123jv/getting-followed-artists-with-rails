class User < ApplicationRecord
	has_many :user_artist_connections
	has_many :artists, through: :user_artist_connections

	validates :uid, presence: true, uniqueness: {case_sensitive: true}
	validates :access_token, length: { minimum: 10 }, uniqueness: true

	#
	# Creates or update User data, to use in "non-api-mode"
	#
	# @param [Hash] .from_omniauthauth_hash gotten from omniauth-spotify
	#
	# @return [User] The updates/created User
	#
	def User.from_omniauth(auth_hash)
		user = find_or_create_by(uid: auth_hash['uid'])
		user.name = auth_hash['info']['name']
		user.access_token = auth_hash['credentials']['token']
		user.refresh_token = auth_hash['credentials']['refresh_token']
		user.save!
		user
	end

	#
	# Generates a new api_access_token for a User, check for collisions
	#
	# @return [SecureRandom] The generated token
	#
	def User.generate_access_token
		token = nil
		begin
			token = SecureRandom.urlsafe_base64
			db_user = User.find_by(api_access_token: token)
		end while not db_user.nil?
		return token
	end

	#
	# Update or create an User with the data passed with an api_access_token, then return this User
	#
	# @param [Hash] update_user_datadata Needs: 'uid', 'name', 'access_token' and 'refresh_token'
	#
	# @return [User] The updated/saved user, or nil if can't save user data
	#
	def User.update_user_data(data)
		user = User.find_or_create_by(uid: data[:uid])
		user.name = data[:name]
		user.access_token = data[:access_token]
		user.refresh_token = data[:refresh_token]
		user.api_access_token = User.generate_access_token()

		if not user.save!
			puts "Failed to save/update USER DATA"
			return nil
		end
		return user
	end
end
