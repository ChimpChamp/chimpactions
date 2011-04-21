module Chimpactions
  #Utility class for ensuring everythign is ready for Chimpactions to do its work
  module Setup
    mattr_accessor :message
    mattr_reader :errors
    @@errors = ActiveSupport::OrderedHash.new
    
    # Make sure we have the right info to proceed.
    def self.ensure_initialization
      @@errors = ActiveSupport::OrderedHash.new
      self.error(:api_key, "Is not set!") if Chimpactions.mailchimp_api_key == "your_mailchimp_api_key" || Chimpactions.mailchimp_api_key.nil?
      self.error(:ses_key, "Is not set!") if Chimpactions.mailchimp_ses_key == "your_mailchimp_ses_key" || Chimpactions.mailchimp_ses_key.nil?
     # self.verify_api_key
      @@message = "Chimpactions::Setup.initialize"
    end
    
    # Were there errors in the setup ?
    def self.ok?
      errors.empty?
    end
    
    # Check the gibbon connection to MailChimp
    # Verify that the API key is good.
    def self.verify
      begin
        Chimpactions.socket.chimpChatter()
      rescue Exception => e
        self.error(:api_key,"BAD API KEY::" << e.message)
        false
      end
    end
    
    private
    # Register an error in the setup.
    def self.error(parameter,message)
      errors[parameter] = message
    end
    

    
  end
end