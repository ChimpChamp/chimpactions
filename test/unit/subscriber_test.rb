require 'test_helper'
require 'chimpactions'
require 'factories/raw_factory'

class SubscriberTest < ActiveSupport::TestCase
  context "List management" do
    setup do
      real_setup #helper
      @user = User.new(:email => "subscriber@notanemail.com", :first_name => "FirstName", :last_name =>"LastName", :favorite_color => "red")
      @first_list = Chimpactions.available_lists[0]
      @second_list = Chimpactions.available_lists[1]
      Chimpactions.available_lists.each do |l| @user.remove_from(l,{:delete_member => true}) end;
    end
    
    teardown do
      Chimpactions.available_lists.each do |l| @user.remove_from(l,{:delete_member => true}) end;
    end
    
    should "repond to Chimpactions merge vars" do
    #  puts "CA API: #{Chimpactions.mailchimp_api_key}"
    #  puts "CS: socket: #{Chimpactions.socket}"
    #  puts "URI : #{Chimpactions.socket.base_api_url()}"
     assert_equal @user.merge_vars(Chimpactions.merge_map), {"FNAME"=>"FirstName", "LNAME"=>"LastName", "EMAIL"=>"subscriber@notanemail.com", "FAV_COL"=>"red"} 
    end
    
    should "add a Subscriber to a given list and confirm" do
      assert_equal @user.add_to(@first_list), true
      assert_equal @user.on_list?(@first_list), true
    end
    
    should "move a Subscriber between two lists and confirm" do
      assert_equal @user.move_to(@second_list), true
      assert_equal @user.on_list?(@second_list), true
      assert_equal @user.subscribed?(@first_list), false
    end
    
    should "remove a subscriber from a given list and confirm" do
       assert_equal @user.add_to(@second_list), true
       assert_equal @user.remove_from(@second_list), true
       assert_equal @user.on_list?(@second_list), true
       assert_equal @user.subscribed?(@second_list), false
    end
    
    should "send a specified Response Email from MailChimp" do
      assert_equal @user.send_response_email(@first_list,'Some name'), true
    end
    
  end # context 
end #Class