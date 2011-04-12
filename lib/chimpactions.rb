module Chimpactions
  
  # Your MailChimp API KEY
  mattr_accessor :mailchimp_api_key # your MailChimp API key
  @@mailchimp_api_key = "your_mailchimp_api_key"
  
  # Your MailChimp SES key
  mattr_accessor :mailchimp_ses_key # your MailChimp ses key
  @@mailchimp_ses_key = "your_mailchimp_ses_key"

  # Merge vars available from your MailChimp account
  mattr_reader :merge_vars
  @@merge_vars = ActiveSupport::OrderedHash.new 
  
  # Default setup for Chimpactions. Run rails generate chimpactions_install to create
  # a fresh initializer with configuration options.
  def self.setup
    yield self
  end


  def self.available_lists
    #connect to the MailChimp account and get a list of the lists!
  end
  
  def self.lists_by_name
    # the lists organized by name, alphabetically
  end
  
  def self.list_ids
    # the ids of all lists
  end
  
  
end