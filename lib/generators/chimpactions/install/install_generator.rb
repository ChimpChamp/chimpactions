require 'rails/generators'
require 'rails/generators/migration'
module Chimpactions
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)
      desc "add the migrations"
      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      desc "Creates a Chimpactions initializer and copy locale files to your application."
      def copy_config_yml
        template "chimpactions.yml", "config/initializers/chimpactions.yml"
      end

      desc "Add the Chimpactions migration to  Rails db/migrate"
      def copy_migrations
        migration_template "add_chimpactions.rb", "db/migrate/add_chimpactions.rb"
      end

      def show_readme
        readme "README" if behavior == :invoke
      end
    end
  end
end