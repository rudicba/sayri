class SettingsController < ApplicationController  
  def index
    if not Setting.srv_user
        Setting.srv_user = 'srvuser'
    end
    if not Setting.srv_password
        Setting.srv_password = 'srvpassword'
    end

    @settings = Setting.unscoped.all
  end

  def update
    p "ghshdflghkflhkdfjlgmbhdflbgh sbli"
    puts params

    Setting.srv_user = params[:srv_user]
    Setting.srv_password = params[:srv_password]

    render "index"

  end
end