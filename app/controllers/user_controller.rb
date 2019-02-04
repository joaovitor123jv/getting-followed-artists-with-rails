class UserController < ApplicationController
  include ApplicationHelper
  include SessionHelper
  include UserHelper
  before_action :user_is_logged?, only: [:show, :artist_index]

  def show
  end

  def artist_index
    puts "===== SEARCHING FOLLOWED ARTISTS ======"

    artists = get_user_artists(current_user)
    return redirect_to root_path if artists.nil?

  end

  private
    #
    # Returns true if the user was authenticated, and redirects to authentication if not
    #
    # @return [nil] Called by before_action
    #
    def user_is_logged?
      redirect_to '/auth/spotify' if not logged_in?
    end
end
