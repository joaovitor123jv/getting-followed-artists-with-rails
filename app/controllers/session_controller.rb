class SessionController < ApplicationController
  include SessionHelper

  #
  # Handle the start of usage
  #
  # @return [String] Rendered HTML (NOT API)
  #
  def create
  end

  #
  # Handles the end of session (not part of API), logs_out the user
  #
  # @return [nil] nil
  #
  def destroy
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
