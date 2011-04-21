module Chimpactions
#The Chimpactions Subscriber is the mix-in module for a 
# local model.
#Once initialized, the local model inherits all Subscriber methods.
#ex.
#<pre>
#class User
# Chimpactions.for(User) # must at least respond_to 'email'
#</pre>
  module Subscriber
    
    attr_accessor :merge_vars
    
    # Remove Subscriber from all lists in the account and add to the specified List
    # @param [String, Fixnum, Chimpactions::List] list
    def move_to(list)
      list = validate_list(list)
    end
    
    # Add the Subscriber to the specified list.
    # @param [String, Fixnum, Chimpactions::List] list
    
    def add_to(list)
      list = validate_list(list)
    end
  
    # Remove the Subscriber from the specified list.
    # @param [String, Fixnum, Chimpactions::List] list
    def remove_from(list)
      list = validate_list(list)
    end
    
    # Send the specified MailChimp pre-defined "Response Email" to this Subscriber
    # @param [String, Fixnum, Chimpactions::List] list
    def send_response_email(list, title)
      list = validate_list(list)
    end
  
    # Check if this Subscriber is on the specified list.
    # @param [String, Fixnum, Chimpactions::List] list
    # @return [Boolean]
    def on_list?(list)
      list = validate_list(list)
    end
    
    # @param [Hash] hash The Chimpactions mergemap 
    def merge_vars(hash = Chimpactions.merge_map)
      collect_merge_vars(hash)
    end

private

  # Sync this Subscriber's info to the MailChimp list.
  # @return [boolean] *true* or *false*
   def sync_to_chimp
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
  
  # Searches the MailChimp list hash by id, web_id, name
  # @param [String, Fixnum, Chimpactions::List] list
  # @return [Chimpactions::List] The Chimpactions List object
  def validate_list(list)
    case list.class.name
      when "List"
        #if it's a List, just send it back...
        list
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
    raise Chimpactions::Exception::NotFoundError.new("Could not locate #{list} in your account. ") if return_list.empty?
    return_list
  end
  
  end #Module
end #Module