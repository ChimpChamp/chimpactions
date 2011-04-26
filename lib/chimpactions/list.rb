module Chimpactions
  # The List class does all kinds of things with your MailChimp lists.
  class List
    include Chimpactions::Utility
    
    cattr_reader :socket
    # The system-wide single socket to the MailChimp mothership.
    @@socket = Chimpactions.socket
    
    # Receiver for Observer pattern.
    # Sets the class level socket to the current Chimpactions module socket.
    def self.new_socket
      @@socket = Chimpactions.socket
    end
    
    # @return [List::Stats]
    attr_reader :stats
  
    # Create a new List object
    # @param [Hash] raw MailChimp API data return see Chimpactions::Subscriber
    def initialize(raw)
      @raw = raw
      @stats = Stats.new(@raw.delete('stats'))
      self
    end
    
    #The raw list data.
    #@return [Hash]
    def data
      @raw
    end

  # MC API v1.3
    # def listMergeVarAdd(string apikey, string id, string tag, string name, array options)
    #   #Add a new merge tag to a given list
    # end
    # 
    # def listMergeVarDel(string apikey, string id, string tag)
    # end
    # 
    # def listMergeVars(string apikey, string id)
    #   #Get the list of merge tags for a given list, including their name, tag, and required setting 
    # end
    # 
    # def listWebhookAdd(string apikey, string id, string url, array actions, array sources)
    # actions : 
      #subscribe	optional - as subscribes occur, defaults to true
      #boolean	unsubscribe	optional - as subscribes occur, defaults to true
      #boolean	profile	optional - as profile updates occur, defaults to true
      #boolean	cleaned	optional - as emails are cleaned from the list, defaults to true
      #boolean	upemail	optiona 
    #   #Add a new Webhook URL for the given list
    # end
    # 
    # def listWebhookDel(string apikey, string id, string url)
    #   #Delete an existing Webhook URL from a given list
    # end
    # 
    # def listWebhooks(string apikey, string id)
    #   #Return the Webhooks configured for the given list 
    # end
  # END MC API

    #The available merge varaibles for the List.
    def merge_vars
      @merge_vars ||= @@socket.listMergeVars(:id => id)
    end
    
    # Checks if there are ANY webhooks for this list
    # @return [boolean]
    def webhook?
      @@socket.listWebhooks(:id => id).empty? ? false : true
    end
    
    # Retrieves webhooks for this List
    # @return [Hash, false]
    def webhooks
      @@socket.listWebhooks(:id => id)
    end
  
    # Sets a webhook for this List
    # @param [Hash] _REQUIRED_ : :url => 'a valid url'
    # @return [true, Hash] true if ok, otherwise an error hash
    def set_webhook(opts)
      @@socket.listWebhookAdd({:id => id}.merge(opts) ) == "true"
    end
    
    # removes the specified url webhook for this List
    # @param [Hash] _REQUIRED_ : :url => 'a valid, currently used url'
    # @return [true, Hash] true if ok, otherwise an error hash
    def remove_webhook(opts)
      @@socket.listWebhookDel({:id => id}.merge(opts) ) == "true"
    end
    
    # The Stats class is a simple wrapper for statistics about the List.
    # <code> my_list.stats.subscriber_total #=> 243 </code>
    class Stats
      include Chimpactions::Utility
    
      def initialize(raw)
        @raw = raw
        self
      end   
      
      #The raw data array of statistic info.
      def data
        @raw
      end
    end #Stats
    
  end #List
  
end #Chimpactions