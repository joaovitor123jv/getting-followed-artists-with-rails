class User < ApplicationRecord
	has_many :artists
	validates :uid, presence: true, uniqueness: {case_sensitive: true}
	validates :access_token, presence: true, length: { minimum: 10 }

	def User.from_omniauth(auth_hash)
		puts "Creating or Finding User"
		user = find_or_create_by(uid: auth_hash['uid'])
		puts "Setting user name"
		user.name = auth_hash['info']['name']
		puts "Setting access token"
		user.access_token = auth_hash['credentials']['token']
		puts "Setting refresh token"
		user.refresh_token = auth_hash['credentials']['refresh_token']
		puts "Updating user data"
		user.save!
		puts "Returning data"
		user
	end
end
