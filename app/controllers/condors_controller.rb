require 'net/ssh'

class CondorsController < ApplicationController

  # GET /condors
  # GET /condors.json
  def index
    @hosts = Host.all
    @hrun= check_running()
    @watched = Setting.condorhosts

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hosts }
    end
  end

  def start
  	@output = runssh(params[:format], 'ls -allh')
  end

  def stop
  	puts runssh(params[:format], 'ls -allh')
  end

  private

  def check_running()
    to_ret = []

  	stdout = runssh('salgan', "condor_status -long | grep UtsnameNodename | uniq | awk '{print $3}' | sed 's/\"//g'")

    stdout.each_line do |line|
     to_ret.push(line.strip.split('.')[0])
    end

    to_ret
  end

  def runssh(hostname, cmd)
  	begin
  		output = ""
  		Net::SSH.start(hostname, Setting.srv_user, :password => Setting.srv_password) do |ssh|
  			output = ssh.exec!(cmd)
  	end
  	rescue SocketError => e
  		puts hostname + ": " + e.message
  	rescue Net::SSH::AuthenticationFailed  => e
  		puts hostname + ": " + e.message
  	rescue Exception => e
  		puts hostname + ": " + e.message
  	else
  		output
  	end
  	output
  end
end
