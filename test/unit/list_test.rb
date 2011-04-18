require 'test_helper'
require 'chimpactions'

class ListTest < ActiveSupport::TestCase

  context "Inspecting for awe." do
    setup do
      @awesome = false
    end
    
    
    should "be awesome" do
      assert_equal @awesome, false
    end
    
  end

end