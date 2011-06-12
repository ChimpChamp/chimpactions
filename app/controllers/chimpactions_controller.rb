class ChimpactionsController < ApplicationController
  def index
    @all_actions  = Chimpactions.actions
    @registered  = Chimpactions.registered_class_name
    @actions = Chimpaction.all
    @lists = Chimpactions.available_lists
  end
  
  # GET /chimpactions/new
  # GET /chimpactions/new.xml
  def new
    @chimpaction = Chimpaction.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @chimpaction }
    end
  end

  # GET /chimpactions/1/edit
  def edit
    @chimpaction = Chimpaction.find(params[:id])
  end

  # POST /chimpactions
  # POST /chimpactions.xml
  def create
    @chimpaction = Chimpaction.new(params[:chimpaction])

    respond_to do |format|
      if @chimpaction.save
        format.html { redirect_to(chimpactions_url, :notice => 'Chimpaction was successfully created.') }
        format.xml  { render :xml => @chimpaction, :status => :created, :location => @chimpaction }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @chimpaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /chimpactions/1
  # PUT /chimpactions/1.xml
  def update
    @chimpaction = Chimpaction.find(params[:id])

    respond_to do |format|
      if @chimpaction.update_attributes(params[:chimpaction])
        format.html { redirect_to(chimpactions_url, :notice => 'Chimpaction was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @chimpaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /chimpactions/1
  # DELETE /chimpactions/1.xml
  def destroy
    @chimpaction = Chimpaction.find(params[:id])
    @chimpaction.destroy

    respond_to do |format|
      format.html { redirect_to(chimpactions_url) }
      format.xml  { head :ok }
    end
  end
end