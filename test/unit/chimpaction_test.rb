require 'test_helper'
require 'chimpactions'
require 'factories/raw_factory'

class ChimpactionTest < ActiveSupport::TestCase
  context "Creating Chimpactions" do
    setup do
      real_setup #helper
    end
    
    teardown do
    end
    
    should "fail validation on a non-action" do
      ca = Chimpaction.new(:action => "not_a_method")
      assert_equal ca.save, false
    end
    
    should "pass validations on a 'good' action" do
      ca = Chimpaction.new(:action => "email")
      assert_equal ca.save, true
    end
    
    
  end # context 
end #Class