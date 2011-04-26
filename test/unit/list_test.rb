require 'test_helper'
require 'chimpactions'

class ListTest < ActiveSupport::TestCase

  context "Webhook checks" do
    setup do
      real_setup #helper
      @user = User.new(:email => "subscriber@notanemail.com", :first_name => "FirstName", :last_name =>"LastName", :favorite_color => "red")
      @first_list = Chimpactions.available_lists[0]
      @second_list = Chimpactions.available_lists[1]
    end
    
    teardown do
      @second_list.remove_webhook(:url => "circuitllc.com")
    end
    
    should "have no webhooks" do
      assert_equal @second_list.webhook?, false
    end
    
    should "add a webhook" do
      assert_equal @second_list.set_webhook(:url => "circuitllc.com"), true
    end
    
    should "remove the webhook" do
      assert_equal @second_list.set_webhook(:url => "circuitllc.com"), true
      assert_equal @second_list.remove_webhook(:url => "circuitllc.com"), true
    end
    
    should "find no webhooks" do
      assert_equal @second_list.webhooks, []
    end
  end

end