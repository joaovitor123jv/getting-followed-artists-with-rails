class SessionController < ApplicationController
  protect_from_forgery with: :exception
  include SessionHelper

  #
  # Handle the start of usage
  #
  # @return [String] Rendered HTML (NOT API)
  #
  def create
    begin
      puts "Getting Data"
      @user = User.from_omniauth(request.env['omniauth.auth'])
      puts "Logging User"
      log_in(@user)
      puts "Setting flash"
      flash[:success] = "Welcome to myArtist, #{@user.name}"
      puts "Redirecting"
      redirect_to user_show_path( @user )

    rescue
      flash[:warning] = "An error was detected while trying authentication"
      redirect_to root_path
    end

  end

  #
  # Handles the end of session (not part of API), logs_out the user
  #
  # @return [nil] nil
  #
  def destroy
    log_out if logged_in?
    flash[:success] = "You was successfully disconnected"
    redirect_to root_path
  end

  #
  # Handles authentication failure
  #
  # @return [nil] nil
  #
  def auth_failure
    flash[:error] = "Failed to get spotify authentication"
    redirect_to root_path
  end
end
