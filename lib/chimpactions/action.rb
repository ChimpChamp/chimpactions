module Chimpactions
  # Defines a single step to take given a set of conditions.
  class Action
    
    #The Chimpaction::Subscriber method to execute for this action.
    attr_accessor :action
    #The Chimpactions::List object to excute the action on.
    attr_accessor :list
    
    attr_accessor :whenn
    attr_accessor :is
    attr_accessor :value 
    
    # @params [String,String,Subscriber,String] {:action, :list, :method, :comparitor, :value}Subscriber method name, = || != || < || >, Subscriber Object, value to test against
    def initialize(params)
      validate_params(params)
      params.each_pair do |key,val|
        self.send(key.to_s << "=", val)
      end
    end
    
    # Check the Object attributes against the specified logic.
    # @param [String,String,Subscriber,String] Subscriber method name, = || != || < || >, Subscriber Object, value to test against
    def perform?(subscriber)
      is = '==' if is == '='
      value = cast_value(self.value)
      value = "\"#{value}\"" if value.class.name == "String"
      eval "subscriber.#{whenn} #{is} #{value}"
    end
    
    # Utility for casting a String to a 'best guess' Type
    # @param [Object]
    # @return [String, Integer, TrueClass, FalseClass]
    def cast_value(val)
      raise ArgumentError.new("Your value is not a String! (it's a #{val.class})") if val.class != String && val.class != TrueClass && val.class != FalseClass
      
      if (Float val rescue false)
        Float val
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
     registered_class = Chimpactions.registered_class.new
     if  !registered_class.respond_to?(p[:action].to_sym)
       error = ":action #{@registered_class} to respond to #{p[:action]}"
     elsif !registered_class.respond_to?(p[:whenn].to_sym)
       error = ":whenn #{registered_class} to repspond to #{p[:whenn]}"
     elsif !p[:list].is_a?(Chimpactions::List)
       error = ":list must be a Chimpactions::List object (you passed #{p[:list]})"
     end
    raise ArgumentError, "Chimpactions::Action expects #{error}", caller if !error.nil?
    end
    
  end #Action
end # module