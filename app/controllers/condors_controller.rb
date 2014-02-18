require 'net/ssh'

class CondorsController < ApplicationController

  # GET /condors
  # GET /condors.json
  def index
    @hosts = Host.all
    @hrun= check_running()
    @watched = load_file()

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

  def watch
    watch_host(params[:format])
    redirect_to condors_path
  end

  def unwatch
    unwatch_host(params[:format])
    redirect_to condors_path
  end

  private

  def load_file()
    to_ret = []
    File.open('public/condorhosts').each_line do |line|
      to_ret.push(line.strip)
    end
    to_ret
  end

  def watch_host(hostname)
    File.open('public/condorhosts', 'a') do |file|
      file.write hostname + "\n"
    end
  end

  def unwatch_host(hostname)
    tmp = Tempfile.new("extract")
    puts hostname
    File.open('public/condorhosts', 'r').each { |l| tmp << l unless l.chomp == hostname.chomp }
    tmp.close
    FileUtils.mv(tmp.path, 'public/condorhosts')
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
  		Net::SSH.start(hostname, '', :password => "") do |ssh|
  			output = ssh.exec!(cmd)
  	end
  	rescue SocketError => e
  		puts hostname + ": " + e.message
  	rescue Net::SSH::AuthenticationFailed
  		puts hostname + ": " + e.message
  	rescue Exception => e
  		puts hostname + ": " + e.message
  	else
  		output
  	end
  	output
  end
end
