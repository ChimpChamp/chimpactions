class HomeController < ApplicationController
  
  def index
    @lists = Chimpactions.available_lists
    @registered = "User"
    @actions = Chimpactions.actions
  end
  
  def change_accounts
    Chimpactions.change_account(params['new_key'])
    redirect_to :root
  end
  
end