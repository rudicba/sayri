module SessionsHelper

  # Remember user session
  def sign_in(user)
    session[:remember_token] = user.id
    self.current_user = user
  end

  # True if loged
  def signed_in?
    !current_user.nil?
  end

  # Set current user
  def current_user=(user)
    @current_user = user
  end

  # Return user of session
  def current_user
    @current_user ||= User.find_by_login(session[:remember_token])
  end

  # True if user es current_user
  def current_user?(user)
    user == current_user
  end

  # True if user is in admin group
  def admin?
    current_user.groups.member? Group.find('Sayri')
    rescue ActiveLdap::EntryNotFound
      false
  end

  # Logout current user
  def sign_out
    self.current_user = nil
    session.delete(:remember_token)
  end
end