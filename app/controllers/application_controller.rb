class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :signed_in_user
  before_filter :admin_user

  include SessionsHelper

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end

  private

  def signed_in_user
    redirect_to signin_url, notice: "Unauthorized access" unless signed_in?
  end

  def admin_user
    redirect_to current_user, notice: "Unauthorized access" unless admin?
  end
end
