class Artist < ApplicationRecord
	belongs_to :user
	validates :followers_number, presence: true
	validates :name, presence: true
	validates :spotify_url, presence: true, uniqueness: true
	validates :user_id, presence: true

end
