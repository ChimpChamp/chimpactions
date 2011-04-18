module Chimpactions
  module Subscriber
    
    attr_accessor :merge_vars
    
    def move_to(list, params)
      case list.class
        when "List"
        when "String"
      end
    end
  
    def add_to(list)
    end
  
    def remove_from(list)
    end
  
    def move_to(list)
    end
    
    def send_response_email(list, title)
    end
  
    def set_custom(merge_var, value)
    end
  
    def on_list?(list)
    end
    
    def merge_vars(hash = Chimpactions.merge_map)
      collect_merge_vars(hash)
    end

private

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
  
  end #Module
end #Module