class HostsController < ApplicationController

  # GET /hosts
  # GET /hosts.json
  def index
    @hosts = Host.all
    @watched = get_watched

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hosts }
    end
  end

  def watch
    Setting.condorhosts =  get_watched | [params[:hostname]]

    redirect_to hosts_path
  end

  def unwatch
    tmp = get_watched
    tmp.delete(params[:hostname])
    Setting.condorhosts = tmp

    redirect_to hosts_path
  end
  
  # GET /hosts/1
  # GET /hosts/1.json
  def show
    @host = Host.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @host }
    end
  end
  
  # GET /hosts/new
  # GET /hosts/new.json
  def new
    @host = Host.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @Host }
    end
  end
  
  # GET /hosts/1/edit
  def edit
    @host = Host.find(params[:id])
  end

  # POST /hosts
  # POST /hosts.json
  def create
    @host = Host.new(params[:host])

    respond_to do |format|
      if @host.save
        format.html { redirect_to hosts_url, notice: @host.cn + ' host was successfully created.' }
        format.json { render json: @host, status: :created, location: @host }
      else
        format.html { render action: "new" }
        format.json { render json: @host.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hosts/1
  # PUT /hosts/1.json
  def update
    @host = Host.find(params[:id])

    respond_to do |format|
      if @host.update_attributes(params[:host])
        format.html { redirect_to hosts_url, notice: @host.cn + ' host was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @host.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hosts/1
  # DELETE /hosts/1.json
  def destroy
    @host = Host.find(params[:id])
    @host.destroy

    respond_to do |format|
      format.html { redirect_to hosts_url, notice: @host.cn + ' host was successfully delete.' }
      format.json { head :no_content }
    end
  end

  private

  def get_watched
    if Setting.condorhosts
      Setting.condorhosts
    else
      []
    end
  end

end