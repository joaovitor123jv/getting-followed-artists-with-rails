module ApplicationHelper
	def extract_artists_ids(spotify_artists)
		ids = []
		spotify_artists['items'].each do |artist|
			ids << artist['id']
		end
		return ids
	end
end
