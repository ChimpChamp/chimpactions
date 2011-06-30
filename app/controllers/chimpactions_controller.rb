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
  
  def webhooks
    @lists = Chimpactions.available_lists
  end
  
  def add_webhook
    list = Chimpactions.list(params[:id])
     if list.set_webhook :url => 'http://www.postbin.org/1iwea1s'#webhook_url
       flash[:notice] = "Added Webhook!"
     end
       redirect_to '/chimpactions/webhooks'
  end
  
  def delete_webhook
    list = Chimpactions.list(params[:id])
     if list.remove_webhook :url => 'http://www.postbin.org/1iwea1s' #webhook_url
       flash[:notice] = "Removed Webhook!"
     end
       redirect_to '/chimpactions/webhooks'
  end
  
  def receive
    if params['data']
      subscriber = Chimpactions.registered_class.find_by_email(params['data']['email'])
      subscriber.receive_webhook(params) if subscriber.respond_to?(:receive_webhook)
    end
      render :nothing => true
  end
# data[email] = 'federico@mailchimp.com'
# 
# data[email_type] = 'html'
# 
# data[id]  = 'da1b07ac4c'
# 
# data[ip_opt]='69.12.4.2'
# 
# data[list_id]='45a650bc63'
# 
# data[merges][EMAIL]='federico@mailchimp.com'
# 
# data[merges][FNAME] ='Federico'
# 
# data[merges][IP] ='127.0.0.1'
# 
# data[merges][LNAME]='Holgado'
# 
# data[merges][SIGNUP]=''
# 
# data[web_id]='234305517'
# 
# fired_at = '2011-06-30 02:34:35'
# 
# type ='profile'
  # end
  
end