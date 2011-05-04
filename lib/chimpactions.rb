# Holds MailChimp account level information
# Should set up wit an initializer.
module Chimpactions
  # ruby wrapper gem for the MailChimp API
  # https://github.com/amro/gibbon

  require 'gibbon'
  autoload :List, 'chimpactions/list'
  autoload :Subscriber, 'chimpactions/subscriber'
  autoload :Utility, 'chimpactions/utility'
  autoload :Action, 'chimpactions/action'
   require 'chimpactions/exception'
  autoload :Setup, 'chimpactions/setup' 
  autoload :ListNotifier, 'chimpactions/notifier' 
  
  # Obersver pattern untility class attribute.
  mattr_accessor :observers
  @@observers = []
  
  # Observer pattern untility.  
  def self.add_observer(observer)
    @@observers << observer
  end
  
  # Observer pattern notify untility. 
  def self.notify_observers(mod)
    @@observers.each do |o|
      o.update(mod)
    end
  end
  
  # Ensure the module has an observer for communicating with List objects.
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

  # Require the user to reply to the MailChimp system before adding to list.
  mattr_accessor :default_double_optin
  @@default_double_optin = false
  
  #Have MailChimp send the "Welcome" email for the list immediately on subscribing.
  mattr_accessor :default_send_welcome
  @@default_send_welcome = true
  
  # When a class includes Chimpactions::Subscriber, it is registered here
  mattr_accessor :registered_classes
  @@registered_classes = Array.new

  # The default email type when subscribing
  mattr_accessor :default_email_type
  @@default_email_type = 'html'
  
  # Udpate existing subscriber (to prevent already subscribed error)
  mattr_accessor :default_update_existing
  @@default_update_existing = true
# END INITIALIZER

  # the gibbon API wrapper object for communication with MailChimp servers
  mattr_accessor :socket
  
  # Assign a local class to the Chimpactions module.
  # @param [Object] The local object to inherit Chimpactions::Subscriber methods.
  # - Must respond_to? 'email'
  # - For methods defined in the Chimpactions merge_map
  # -- can to respond_to? each method
  # -- if it doesn not, Chimpactions will not send the merge variable or value.
  def self.for(klass)
    raise Chimpactions::SetupError.new("The #{klass.name} class MUST at least respond to 'email' !") if !klass.new.respond_to?(:email)
    klass.class_eval <<-INC
      include Chimpactions::Subscriber
    INC
    @@registered_classes << klass if !@@registered_classes.include? klass
  end
  
  # Change the MailChimp used by the system.
  # Notifies all list objects and reloads the available lists from the new account.
  # @param [String] A new API key
  def self.change_account(new_api_key)
    self.mailchimp_api_key = new_api_key
    self.socket = Gibbon::API.new(self.mailchimp_api_key)
    notify_observers self
    self.available_lists(true)
  end

  # The registered class
  # @return [ClassName]
  def self.registered_class
    self.registered_classes[0]
  end
  
  # Default setup for Chimpactions. Run rails generate chimpactions_install to create
  # a fresh initializer with configuration options.
  def self.setup(config)
    self.mailchimp_api_key = config['mailchimp_api_key']
    self.merge_map = config['merge_map']
    self.mailchimp_ses_key = config['mailchimp_ses_key']
    self.for(Kernel.const_get(config['local_model']))
    #yield self
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
  
  
  # Searches the MailChimp list hash by id, web_id, name
  # @param [String, Fixnum, Chimpactions::List] list
  # @return [Chimpactions::List] The Chimpactions List object
  def self.list(list)
    case list.class.name
      when "Chimpactions::List"
        #if it's a List, just send it back...
        return_list = [list]
      when "String"
        # The List.name , id, or web_id ?
        return_list = Chimpactions.available_lists.select{|l| l.id == list}
        return_list = Chimpactions.available_lists.select{|l| l.web_id == list.to_i} if return_list.empty?
        return_list = Chimpactions.available_lists.select{|l| l.name == list} if return_list.empty?
      when "Fixnum"
        return_list = Chimpactions.available_lists.select{|l| l.web_id == list.to_i}
      else 
        return_list = []
    end
    raise Chimpactions::NotFoundError.new("Could not locate #{list} in your account. ") if return_list.empty?
    return_list[0]
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