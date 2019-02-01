class UserController < ApplicationController
  include SessionHelper
  before_action :user_is_logged?, only: [:show, :artist_index]

  def show
  end

  def artist_index
    puts "===== SEARCHING FOLLOWED ARTISTS ======"
    if not current_user.artists.first.nil?
      pp current_user.artists.all
      return render '/user/artist_index'

    else
      puts "===== ARTISTAS NULOS, INICIANDO REQUISIÇÂO ======"
      base_url = 'https://api.spotify.com'
      puts "Base URL DEFINED"
      uri = '/v1/me/following?type=artist'
      puts "URI DEFINED"
      params = { access_token:  current_user.access_token }
      puts "Access token GET"
      
      begin
        puts "Starting requisition"
        response = RestClient.get((base_url + uri), { params: params })
        artists = JSON.parse(response.body)['artists']
        artists_number = artists['total']
        puts "Total de artistas = #{artists_number}"


        puts "ARMAZENANDO DADOS DE ARTISTAS !!!!"
        artists['items'].each do |artist|
          to_store = current_user.artists.new( 
            name: artist['name'],
            followers_number: artist['followers']['total'],
            spotify_url: artist['external_urls']['spotify'])

          if to_store.save
            puts "DATA SAVED"
          else
            puts "DATA NOT SAVED"
          end
        end
        
      rescue RestClient::ExceptionWithResponse => e
        puts "ERROR ASKJDHASKJDHSAJKDHJSK"
        puts e.response
        pp e.response.body.to_json
      end

    end
    puts "======================================="
    redirect_to root_path
  end

  private
    def user_is_logged?
      redirect_to '/auth/spotify' if not logged_in?
    end
end
