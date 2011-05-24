require "chimpactions"
require "rails"

module Chimpactions
 class Engine < Rails::Engine
    initializer "engine.configure_rails_initialization" do
      Chimpactions.setup(YAML.load_file("#{Rails.root}/config/initializers/chimpactions.yml"))
    end
 end
end