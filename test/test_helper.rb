  require 'simplecov'
  SimpleCov.start 'rails'
  
# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require 'shoulda'
require 'factory_girl'
# Load all the factories
Dir["#{File.dirname(__FILE__)}/factories/*.rb"].each { |f| require f }

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = "test.com"

Rails.backtrace_cleaner.remove_silencers!

# Configure capybara for integration testing
require "capybara/rails"
Capybara.default_driver   = :rack_test
Capybara.default_selector = :css

# Run any available migration
ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

require 'mocha'

def mock_setup
  Chimpactions.setup(
  {'mailchimp_api_key' => "notreallanapikey",
  'merge_map' => {
    'FNAME'=> 'first_name',
    'LNAME' => 'last_name',
    'EMAIL' => 'email',
    'FAV_COL' => 'favorite_color'
  },
  'local_model' => 'User'
})

  @raw_data = Factory.build(:raw_lists)
  Gibbon::API.any_instance.stubs(:lists).returns(raw_list_hash)
end

def real_setup
Chimpactions.setup(
  {'mailchimp_api_key' => "aefe9dae400a886bf13ac7eee94e7528-us2",
  'merge_map' => {
    'FNAME'=> 'first_name',
    'LNAME' => 'last_name',
    'EMAIL' => 'email',
    'FAV_COL' => 'favorite_color'
  },
  'mailchimp_ses_key' => "0987654321",
  'local_model' => 'User'
})
Chimpactions.change_account('aefe9dae400a886bf13ac7eee94e7528-us2')
end