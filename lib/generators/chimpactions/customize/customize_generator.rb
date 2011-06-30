require 'rails/generators'
require 'rails/generators/migration'
module Chimpactions
  module Generators
    class CustomizeGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates/views', __FILE__)
      def copy_views
        # Views template 
          copy_file "index.html.erb", "app/views/chimpactions/index.html.erb"
          copy_file "edit.html.erb", "app/views/chimpactions/edit.html.erb"
          copy_file "new.html.erb", "app/views/chimpactions/new.html.erb"
          copy_file "_form.html.erb", "app/views/chimpactions/_form.html.erb"
          copy_file "_errors.html.erb", "app/views/chimpactions/_errors.html.erb"
          copy_file "webhooks.html.erb", "app/views/chimpactions/webhooks.html.erb"
      end
    end
  end
end
