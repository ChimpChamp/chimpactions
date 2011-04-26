  require 'simplecov'
  SimpleCov.start 'rails'
  
# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require 'shoulda'
require 'factory_girl'

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
  Chimpactions.setup do |config|
    config.mailchimp_api_key = 'notreallyanapikey'
    config.merge_map = {
      'FNAME'=> 'first_name',
      'LNAME' => 'last_name',
      'EMAIL' => 'email',
      'FAV_COL' => 'favorite_color'
    }        
  end
  @raw_data = Factory.build(:raw_lists)
  Gibbon::API.any_instance.stubs(:lists).returns(raw_list_hash)
end

def real_setup
Chimpactions.setup do |config|
    # Your MailChimp API key.
  config.mailchimp_api_key = "aefe9dae400a886bf13ac7eee94e7528-us2"
  config.merge_map = {
    'FNAME'=> 'first_name',
    'LNAME' => 'last_name',
    'EMAIL' => 'email',
    'FAV_COL' => 'favorite_color'
  }
  # Your MailChimp SES key.
  config.mailchimp_ses_key = "0987654321"
end
Chimpactions.change_account('aefe9dae400a886bf13ac7eee94e7528-us2')
end