require 'test_helper'
require 'chimpactions'
require 'factories/raw_factory'

class ActionTest < ActiveSupport::TestCase

  context "Taking actions" do
    setup do
      mock_setup
      @user = User.new(:email => "subscriber@notanemail.com", :first_name => "FirstName", :last_name =>"LastName", :favorite_color => "red")
      User.any_instance.stubs(:is_great).returns(true)
      User.any_instance.stubs(:is_clean).returns(false)
      @action1 = Chimpactions::Action.new({:action => "add_to", :list => Chimpactions.available_lists[0], :whenn => "is_great", :is => '=', :value => true})
      @action2 = Chimpactions::Action.new({:action => "move_to", :list => Chimpactions.available_lists[1], :whenn => "is_clean", :is => '=', :value => true})
      
    end
    
    should "not allow the creation af an Action that does not repspond_to properly" do
      assert_raise Chimpactions::ArgumentError do Chimpactions::Action.new({:action => "move_to", :list => Chimpactions.available_lists[1], :whenn => "not_a_method", :is => '=', :value => true}) end;
      assert_raise Chimpactions::ArgumentError do Chimpactions::Action.new({:action => "not_a_method", :list => Chimpactions.available_lists[1], :whenn => "is_great", :is => '=', :value => true}) end;
      assert_raise Chimpactions::ArgumentError do Chimpactions::Action.new({:action => "move_to", :list => "Not a List Object", :whenn => "is_great", :is => '=', :value => true}) end;
    end
    
    should "return the appropriate class object when cast" do
      assert_equal Float, @action1.cast_value("123").class
      assert_equal Float, @action1.cast_value("123.00234").class
      assert_equal FalseClass, @action1.cast_value("false").class
      assert_equal TrueClass, @action1.cast_value("true").class
    end
    
    
    should "take a required action" do
      assert_equal true, @action1.perform?(@user)
    end

    should "not take an action that's not met" do
      assert_equal false, @action2.perform?(@user)
    end
  end #context
  
end # class