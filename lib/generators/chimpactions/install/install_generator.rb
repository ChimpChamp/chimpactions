require 'rails/generators'
require 'rails/generators/migration'
module Chimpactions
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      desc "Creates a Chimpactions initializer and copy locale files to your application."
      def copy_config_yml
        copy_file "chimpactions.yml", "config/chimpactions.yml"
      end
      
      def show_readme
        readme "README" if behavior == :invoke
      end
    end
  end
end