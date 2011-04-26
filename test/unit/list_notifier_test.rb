require 'test_helper'
require 'chimpactions'

class ListNotifierTest < ActiveSupport::TestCase

  context "When assigning a new socket" do
    setup do
      mock_setup
      @old_socket = Chimpactions.socket
      Chimpactions.change_account('123456')
      @new_socket = Chimpactions.socket
    end
    
    
    should "share the socket with List class" do
      assert_equal Chimpactions.observers[0].update(Chimpactions), @new_socket
      # to get the coverage...
      obs = Chimpactions::ListNotifier.new
      obs.update(Chimpactions) 
      assert_equal Chimpactions::List.socket, @new_socket
      assert_equal Chimpactions::List.new_socket, @new_socket
    end
    
    should "notify the List class of a new socket" do
      Chimpactions.notify_observers(Chimpactions)
      assert_equal Chimpactions.available_lists[0].socket, @new_socket
    end
    
    should "load a new account" do
    end
    
  end

end