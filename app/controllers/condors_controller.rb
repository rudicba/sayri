require 'net/ssh'

class CondorsController < ApplicationController

  # GET /condors
  # GET /condors.json
  def index
    #watched: Host que estan siendo vigilados
    @watched = Setting.condorhosts

    #hrun: Host corriendo condor
    @hrun = check_running()

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hosts }
    end
  end

  def start
  	out = runssh(params[:hostname], 'sudo /usr/sbin/service condor start')

    redirect_to condors_path, notice: out
  end

  def stop
    out = runssh(params[:hostname], 'sudo /usr/sbin/service condor stop')

    redirect_to condors_path, notice: out  
  end

  private

  def ping_hosts(hosts)
    ret = []
    hosts.each do |host|
      ret << host if Net::Ping::TCP.new(host, timeout=1).ping?
    end
    ret
  end

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
  		Net::SSH.start(hostname, Setting.srv_user, :password => Setting.srv_password, :timeout => 5) do |ssh|
  			output = ssh.exec!(cmd)
  	end
    rescue Timeout::Error => e
      output = hostname + ": " + e.message
  	rescue SocketError => e
  		output =  hostname + ": " + e.message
  	rescue Net::SSH::AuthenticationFailed  => e
  		output =  hostname + ": " + e.message
  	rescue Exception => e
  		output =  hostname + ": " + e.message
  	end
  end
end
