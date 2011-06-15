require 'rubygems'
require 'chimpactions'

module Chimpactions
  class Railtie < Rails::Railtie
    
    initializer "setup" do 
    end

    initializer "verify setup" do
      config.after_initialize do
      end
    end
    
  end
end