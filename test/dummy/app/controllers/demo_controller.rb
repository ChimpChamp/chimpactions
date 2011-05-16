class DemoController < ApplicationController
  before_filter :logged_in?, :except => [:signup, :new]
  
  def index
    @lists = Chimpactions.available_lists
    @registered = "User"
    @user = current_user
  end
  
  def leave
    session[:user_id] = nil
    flash[:message] = "BYE!"
    redirect_to '/demo/new'
  end
  
  def signup
    @user = current_user || User.find_by_email(params[:user]['email'])
    if (@user)
      session[:user_id] = @user.id
      flash[:message] = "YOU ARE BACK! #{@user.email}"
      redirect_to '/demo'
    else
      @params = params
      @user = User.new(params[:user])
      @user.status = 'registered'
      if @user.save
        session[:user_id] = @user.id
        flash[:message] = "YOU ARE SIGNED UP! #{@user.email}"
        redirect_to '/demo'
      else
        flash[:message] = "#{@user.email} is not an email!"
        redirect_to '/demo/new'
      end
    end

  end
  
  def user
    @user  = current_user
  end
  
  def remove
    current_user.status = "cancelled"
    current_user.save
    flash[:message] = "We cancelled you!"
    redirect_to '/demo'
  end
  
  def upgrade
    current_user.status = "registered"
    current_user.save
    flash[:message] = "Your status has been upgraded!"
    redirect_to '/demo'
  end
  
  def logged_in?
    redirect_to '/demo/new' if !current_user
  end
  
end