module Chimpactions
#The Chimpactions Subscriber is the mix-in module for a 
# local model.
#Once initialized, the local model inherits all Subscriber methods.
#ex.
#<pre>
# see chimpaction.yml for initializtaion options
#</pre>
  module Subscriber
    
    attr_accessor :merge_vars
    
# listSubscribe(string apikey, string id, string email_address, array merge_vars, string email_type, bool double_optin, bool update_existing, bool replace_interests, bool send_welcome)
# 
# Subscribe the provided email to a list.
# 
# listUnsubscribe(string apikey, string id, string email_address, boolean delete_member, boolean send_goodbye, boolean send_notify)
# 
# Unsubscribe the given email address from the list
    
    # Add the Subscriber to the specified list.
    # @param [String, Fixnum, Chimpactions::List] list
    def add_to(list, opts={})
      list = validate_list(list)
      list.socket.listSubscribe({:id => list.id, :email_address => self.email, 
        :merge_vars => self.merge_vars, :send_welcome => Chimpactions.default_send_welcome,
        :double_optin => Chimpactions.default_double_optin,
        :update_existing => Chimpactions.default_update_existing}.merge opts) == "true"
    end
    
    # Remove Subscriber from all lists in the account and add to the specified List
    # @param [String, Fixnum, Chimpactions::List] list
    def move_to(list)
      list = validate_list(list)
      # add to the specified list
      if add_to(list) == true
        #remove from all the others
        Chimpactions.available_lists.each do |l|
          remove_from(l) if l != list 
        end
        true
      else
        false
      end
    end
  
    # Remove the Subscriber from the specified list.
    # @param [String, Fixnum, Chimpactions::List] list
    def remove_from(list, opts={})
      list = validate_list(list)
      list.socket.listUnsubscribe({:id => list.id, :email_address => self.email}.merge opts) == "true"
    end
    
    # Send the specified MailChimp pre-defined "Response Email" to this Subscriber
    # @param [String, Fixnum, Chimpactions::List] list
    def send_response_email(list, title)
      list = validate_list(list)
      false # stub for test failure
    end
  
    # Check if this Subscriber is on the specified list.
    # @param [String, Fixnum, Chimpactions::List] list
    # @return [Boolean]
    def on_list?(list, opts={})
      list = validate_list(list)
      answer = list.socket.listMemberInfo({:id => list.id, :email_address => self.email}.merge opts)
      answer['success'] == 1 && answer['errors'] == 0
    end
    
    # Check if this Subscriber is 'subscribed' to the list.
    # @param [String, Fixnum, Chimpactions::List] list
    # @return [Boolean]
    def subscribed?(list,opts={})
      list = validate_list(list)
      answer = list.socket.listMemberInfo({:id => list.id, :email_address => self.email}.merge opts)
      answer['data'][0]['status'] == 'subscribed'
    end
    
    # @param [Hash] hash The Chimpactions mergemap 
    def merge_vars(hash = Chimpactions.merge_map)
      collect_merge_vars(hash)
    end

private

  # Sync this Subscriber's info to the MailChimp list.
  # @return [boolean] *true* or *false*
   def sync_to_chimp
     Chimpactions.available_lists.each do |l|
       add_to(l)
     end
   end


   # Calls the specified method/attribute on the mix-in target
   # @param [Hash] {'MAILCHIMP_MERGE_VAR' => 'model_attribute_or_method'}
   # @return [Hash]
   def collect_merge_vars(merge_hash)
     merge_vars = Hash.new
     merge_hash.each_pair do |key,val|
      if self.respond_to?(val)
        method_object = self.method(val.to_sym) 
        merge_vars[key] = method_object.call
      end
    end
    merge_vars
   end
  
  # Wrapper for Chimpactions module list method
  # @see Chimpactions.list(list)
  def validate_list(list)
    Chimpactions.list(list)
  end
  
  end #Module
end #Module