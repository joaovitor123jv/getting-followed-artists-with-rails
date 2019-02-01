module SessionHelper

  #
  # Stores a user id in session variables, logs in the user in the Web demonstration
  #
  # @param [User] user User that will be considered logged_in
  #
  # @return [nil] nil
  #
  def log_in(user)
    session[:user_id] = user.id
  end

  #
  # Ends the user session, deleting its entries in session variable
  #
  # @return [nil] nil
  #
  def log_out
    session.delete :user_id
    @current_user = nil
  end

  #
  # Returns true if the user id logged in
  #
  # @return [nil] nil
  #
  def logged_in?
  # By now, the user can't login, cause I haven't created a login method yet
    !session[:user_id].nil?
  end


  #
  # Returns the logged user
  #
  # @return [User] The logged user, nil if not logged
  #
  def current_user
    (@current_user ||= User.find_by(id: session[:user_id])) if logged_in?
  end
end
