require "chimpactions"
require "rails"

module Chimpactions
 class Engine < Rails::Engine
    initializer "engine.configure_rails_initialization" do
      if File.exists?("#{Rails.root}/config/initializers/chimpactions.yml") 
        setup_hash = YAML.load_file("#{Rails.root}/config/initializers/chimpactions.yml")
        model_test =  Kernel.const_get(setup_hash['local_model'].to_s.capitalize) #rescue false 
        if model_test != false
          Chimpactions.setup(setup_hash) 
          Kernel.const_get( Chimpactions.registered_class.class.to_s.capitalize).send(:include, Chimpactions::Subscriber)
        end
      else 
       # raise Chimpactions::SetupError.new("*** Chimpactions Gem has no config file! (try rails generate chimpactions:install) ***")
      end
    end
 end
end