module Chimpactions
  # Defines a single step to take given a set of conditions.
  class Action
    
    #The Chimpaction::List method to execute for this action.
    attr_accessor :action
    #The Chimpactions::List object to excute the action on.
    attr_accessor :list
    
    def initialize(params)
      validate_params(params)
      params.each_pair do |key,val|
        self.send(key.to_s << "=", val)
      end
    end
    
    # Check the Object attributes against the specified logic.
    # @param [String,String,Subscriber,String] Subscriber method name, = || != || < || >, Subscriber Object, value to test against
    def perform?(method, comparitor, subscriber, value)
      comparitor = '==' if comparitor == '='
      value = "\"#{value}\"" if value.class.name == "String"
      eval "subscriber.#{method} #{comparitor} #{value}"
    end
    
    # Utility for casting a String to a 'best guess' Type
    # @param [Object]
    # @return [String, Integer, TrueClass, FalseClass]
    def cast_value(val)
      raise ArgumentError.new("Your value is not a String! (it's a #{val.class})") if val.class != String
      
      if (Float val rescue false)
        Float val
      elsif (Bignum val rescue false)
        Bignum val
      elsif (Integer val rescue false)
        Integer val
      elsif val =~ /^true$/i || val == true
        true
      elsif val =~ /^false$/i || val == false
        false
      else
        val
      end
    end
    
    # Allows this action to be performed on mutiple Subscriber objects.
    def perform_on(*subscribers)
      subscribers.flatten!.each do |s|
        puts s
      end
    end
    
    # Ensures initialization parameters are valid.
    # @param [Hash]
    def validate_params(p)
      if ( !p[:action] || !p[:list] || !p[:subscriber] ) || !Chimpactions.registered_class.respond_to?(p[:action].to_sym) || !p[:list].is_a?(Chimpactions::List)
        raise ArgumentError, "Chimpactions::Action expects : {:list => Chimpactions::List, :action => Chimpactions::Subscriber method name}", caller
      end
    end
    
  end #Action
end # module