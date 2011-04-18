module Chimpactions
  # ruby wrapper gem for the MailChimp API
  # https://github.com/amro/gibbon

  require 'gibbon'
  autoload :List, 'chimpactions/list'
  autoload :Subscriber, 'chimpactions/subscriber'
  autoload :Utility, 'chimpactions/utility'
  autoload :Action, 'chimpactions/action'
  autoload :Exception, 'chimpactions/exception'
  autoload :Setup, 'chimpactions/setup' 
  autoload :ListNotifier, 'chimpactions/notifier' 
  
  mattr_accessor :observers
  @@observers = []
    
  def self.add_observer(observer)
    @@observers << observer
  end
  
  def self.notify_observers(mod)
    @@observers.each do |o|
      o.update(mod)
    end
  end
  
  add_observer Chimpactions::ListNotifier.new 
# BELOW ATTRIBUTES SET IN INSTALLED INITIALIZER
# => try rake chimpactions:install for full option initilaizer

  # ALL merge variables from anywhere in your MailChimp account
  mattr_accessor :merge_map
  @@merge_map = Hash.new
  
  # Your MailChimp API KEY
  mattr_accessor :mailchimp_api_key # your MailChimp API key
  @@mailchimp_api_key = "your_mailchimp_api_key"
  
  # Your MailChimp SES key
  mattr_accessor :mailchimp_ses_key # your MailChimp ses key
  @@mailchimp_ses_key = "your_mailchimp_ses_key"
  
  # When a class includes Chimpactions::Subscriber, it is registered here
  mattr_accessor :registered_classes
  @@registered_classes = Array.new

# END INITIALIZER

  # the gibbon API wrapper object for communication with MailChimp servers
  mattr_accessor :socket

  def self.for(klass)
    raise Chimpactions::Exception::SetupError.new("The #{klass.name} class MUST at least respond to 'email' !") if !klass.new.respond_to?(:email)
    klass.class_eval <<-INC
      include Chimpactions::Subscriber
    INC
    @@registered_classes << klass if !@@registered_classes.include? klass
  end
  
  def self.change_account(new_api_key)
    self.mailchimp_api_key = new_api_key
    self.socket = Gibbon::API.new(self.mailchimp_api_key)
    notify_observers self
    self.available_lists(true)
  end

  # Default setup for Chimpactions. Run rails generate chimpactions_install to create
  # a fresh initializer with configuration options.
  def self.setup
    yield self
    self.socket = Gibbon::API.new(self.mailchimp_api_key)
  end

  # Queries your MailChimp account for available lists.
  # @return [Hash] ChimpActions::List objects available in your account.
  #TODO: What if there are an unmanageable (50+) number of lists? Paginate?
  def self.available_lists(force=false)
    if force
      @available_lists = socket.lists['data'].map{|raw_list| Chimpactions::List.new(raw_list)}
    else
      @available_lists ||= socket.lists['data'].map{|raw_list| Chimpactions::List.new(raw_list)}
    end
  end
  
  # Find a list by any list attribute
  # @param [Hash] :attribute => 'value'
  # @return Chimpactions::List object
  def self.find_list(params)
    available_lists.find{|list| list.method(:params[0].to_s).call == params[1]}
  end

  # Utility for a hash of lists keyed by name in your MailChimp account.
  # @return [Hash] Lists available in your MailChimp account, keyed by name. 
  def self.lists_by_name
     available_lists.sort{|a,b| a.name <=> b.name}
  end
  
  # Utility for a hash of lists keyed by ID.
  # @return [Hash] Lists available in your MailChimp account, keyed by id
  def self.list_ids
    available_lists.sort{|a,b| a.id <=> b.id}
  end
  
  
end