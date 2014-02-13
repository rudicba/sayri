class SudoersController < ApplicationController
  
  # GET /sudoers
  # GET /sudoers.json
  def index
    @title = "Sudoers"
    @sudoers = Sudoer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sudoers }
    end
  end
  
  # GET /sudoers/1
  # GET /sudoers/1.json
  def show
    @sudoer = Sudoer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sudoer }
    end
  end
  
  # GET /sudoers/new
  # GET /sudoers/new.json
  def new
    @title = "New sudoer"
    @sudoer = Sudoer.new  
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sudoer }
    end
  end
  
  # GET /sudoers/1/edit
  def edit
    @sudoer = Sudoer.find(params[:id])
    @title = @sudoer.cn
  end

  # POST /sudoers
  # POST /sudoers.json
  def create
    @sudoer = Sudoer.new(params[:sudoer])

    respond_to do |format|
      if @sudoer.save
        format.html { redirect_to @sudoer, notice: 'Sudoer was successfully created.' }
        format.json { render json: @sudoer, status: :created, location: @sudoer }
      else
        format.html { render action: "new" }
        format.json { render json: @sudoer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sudoers/1
  # PUT /sudoers/1.json
  def update
    @sudoer = Sudoer.find(params[:id])

    respond_to do |format|
      if @sudoer.update_attributes(params[:sudoer])
        format.html { redirect_to @sudoer, notice: 'Sudoer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sudoer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sudoers/1
  # DELETE /sudoers/1.json
  def destroy
    @sudoer = Sudoer.find(params[:id])
    @sudoer.destroy

    respond_to do |format|
      format.html { redirect_to sudoers_url }
      format.json { head :no_content }
    end
  end
end