Rails.application.config.middleware.use OmniAuth::Builder do
	spotify_key = "8bef092bb85d45f5a38a246eeca7ab15"
	spotify_secret = "ffb46d3e5f78400686a952cd784eb331"

	# Determines what kind of data spotify can return
	scope = 'user-follow-read'

	# provider :spotify, ENV['SPOTIFY_KEY'], ENV['SPOTIFY_SECRET']
	ENV['SPOTIFY_KEY'] = spotify_key
	ENV['SPOTIFY_SECRET'] = spotify_secret
	ENV['SPOTIFY_SCOPE'] = scope

	provider :spotify, spotify_key, spotify_secret, { 
		scope: scope 
	}

end

# If authentication find some error, redirect to root_path
OmniAuth.config.on_failure = Proc.new do |env|
	SessionsController.action(:auth_failure).call(env)
end