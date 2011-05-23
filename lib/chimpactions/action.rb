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
      params.each_pair do |key,val|
      #  puts "#{key} => #{val}"
        self.send(key.to_s.dup << "=", val)
      end
    end
    
    def execute(subscriber)
      if perform?(subscriber)
        puts "*** PERFORMING : subscriber.#{action}(\"#{list}\")"
        eval "subscriber.#{action}(\"#{list}\")"
      end
    end
    
    # Check the Object attributes against the specified logic.
    # @param [String,String,Subscriber,String] Subscriber method name, = || != || < || >, Subscriber Object, value to test against
    def perform?(subscriber)
    #  puts "#{is}"
      if  is.eql?("=")
        is = '==' 
      end
     # puts "#{is}"
      value = cast_value(self.value)
      value = "\"#{value}\"" if value.class.name == "String"
    #  puts "*** CHECKING : subscriber.#{whenn} #{is} #{value}"
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
    
    
  end #Action
end # module