module Chimpactions
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a Chimpactions initializer and copy locale files to your application."
      def copy_initializer
        template "chimpactions_initializer.rb", "config/initializers/chimpactions.rb"
        template "chimpactions.yml", "config/initializers/chimpactions.yml"
      end
    
      def show_readme
        readme "README" if behavior == :invoke
      end
    end
  end
end