require 'test_helper'
require 'chimpactions'
require 'factories/raw_factory'

class ChimpactionTest < ActiveSupport::TestCase
  context "Creating Chimpactions" do
    setup do
      real_setup #helper
      action_hash
    end
    
    teardown do
    end
    
    should "fail validation on a non-action" do
      data = @action_hash
      data[:action] = 'not_a_method'
      ca = Chimpaction.new(data)
      assert_equal ca.save, false
    end
    
    should "pass validations on a 'good' action" do
      ca = Chimpaction.new(@action_hash)
      assert_equal ca.save, true
    end
    
    
  end # context 
end #Class