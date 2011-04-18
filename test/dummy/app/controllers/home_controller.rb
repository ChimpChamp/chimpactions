class HomeController < ApplicationController
  
  def index
    @lists = Chimpactions.available_lists
    @registered = Chimpactions.registered_classes
  end
  
  def change_accounts
    #render :inline => "<h1>CHANGE YOUR ACCOUNT</h1>", :layout => true
    Chimpactions.change_account(params['new_key'])
    redirect_to :root
  end
  
end