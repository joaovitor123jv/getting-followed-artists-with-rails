class CreateUserArtistConnections < ActiveRecord::Migration[5.2]
  def change
    create_table :user_artist_connections do |t|
      t.integer :user_id
      t.integer :artist_id

      t.timestamps
    end
  end
end
