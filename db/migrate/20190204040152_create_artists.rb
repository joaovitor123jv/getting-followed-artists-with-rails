class CreateArtists < ActiveRecord::Migration[5.2]
  def change
    create_table :artists do |t|
      t.integer :followers_number
      t.string :name
      t.string :spotify_url
      t.string :uid

      t.timestamps
    end
    add_index :artists, :uid
  end
end
