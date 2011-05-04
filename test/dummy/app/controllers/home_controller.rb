class HomeController < ApplicationController
  
  def index
    @lists = Chimpactions.available_lists
    @registered = Chimpactions.registered_classes
  end
  
  def change_accounts
    Chimpactions.change_account(params['new_key'])
    redirect_to :root
  end
  
end