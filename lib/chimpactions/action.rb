module Chimpactions
  class Action
    # Default setup for Chimpactions. Run rails generate chimpactions_install to create
    # a fresh initializer with configuration options.
    def self.setup
      yield self
    end
    
    #The Chimpaction::List method to execute for this action.
    attr_reader :action
    #The Chimpactions::List object to excute the action on.
    attr_accessor :list
    #The Chimpaction::Subscriber to execute the action with.
    attr_accessor :subscriber
    
    def initialize(params)
      validate_params(params)
      self.list = params[:list]
      self.subscriber = params[:subscriber]
      @action = params[:action]
    end
    
    def execute
      list
    end
    
    def validate_params(p)
      if ( !p[:action] || !p[:list] || !p[:subscriber] ) || !p[:list].respond_to?(p[:action].to_sym) || !p[:list].is_a?(Chimpactions::List) || !p[:subscriber].is_a?(Chimpactions::Subscriber)
        raise ArgumentError, "Chimpactions::Action expects : {:list => Chimpactions::List, :subscriber => Chimpactions::Subscriber (or mixed-in), :action => Chimpactions::List method name}", caller
      end
    end
    
  end #Action
end # module