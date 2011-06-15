require "chimpactions"
require "rails"

module Chimpactions
 class Engine < Rails::Engine
    initializer "engine.configure_rails_initialization" do
      if File.exists?("#{Rails.root}/config/chimpactions.yml") 
        setup_hash = YAML.load_file("#{Rails.root}/config/chimpactions.yml")
        model_test =  Kernel.const_get(setup_hash['local_model'].to_s.capitalize) rescue false 
        if model_test != false
          Chimpactions.setup(setup_hash)
          Kernel.const_get(Chimpactions.registered_class_name.to_s.capitalize).send(:include, Chimpactions::Subscriber)
        else
          raise Chimpactions::SetupError.new("The #{setup_hash['local_model'].to_s.capitalize} class was not found!")
        end
      else 
        
      end
    end
 end
end