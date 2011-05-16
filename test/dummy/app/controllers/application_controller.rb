class ApplicationController < ActionController::Base
  protect_from_forgery
  
  
    def current_user
      @current_user ||= session[:user_id] && User.find(session[:user_id])
      session[:user_id] = @current_user.id if @current_user
      @current_user
    end
end
