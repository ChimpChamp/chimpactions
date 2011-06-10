require 'Chimpactions'
require 'rails'

module Chinmpactions
  class Railtie < Rails::Railtie
    rake_tasks do
      Dir[File.join(File.dirname(__FILE__),'tasks/*.rake')].each { |f| load f }
        #require 'template_wrapper/lib/tasks/template_wrapper.rake'
      end
    end
  end
end