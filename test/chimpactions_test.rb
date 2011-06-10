require 'test_helper'

class ChimpactionsTest < ActiveSupport::TestCase
  context "List checks" do
    setup do
      mock_setup
      @raw_data = Factory.build(:raw_lists)
      Gibbon::API.any_instance.stubs(:lists).returns(raw_list_hash)
    end

    should "raise NotFoundError for a non-existent List" do
      assert_raise Chimpactions::NotFoundError do Chimpactions.list(nil) end;
    end
    
    should "return the right list when a list id is passed" do
      assert_equal Chimpactions.list("49226915c5"), Chimpactions.available_lists[0]
    end
    
    should "return the right list when a list web_id is passed" do
      assert_equal Chimpactions.list(447953), Chimpactions.available_lists[0]
    end
    
    should "return the right list when a list name is passed" do
      assert_equal Chimpactions.list("Chimpactions Registered Users"), Chimpactions.available_lists[0]
    end
    
    should "return the right Stats object for a List" do
      assert_equal Chimpactions.available_lists[0].stats.data.keys, {"member_count"=>0, "unsubscribe_count"=>0, "cleaned_count"=>0, "member_count_since_send"=>0, "unsubscribe_count_since_send"=>0, "cleaned_count_since_send"=>0, "campaign_count"=>0, "grouping_count"=>0, "group_count"=>0, "merge_var_count"=>2, "avg_sub_rate"=>nil, "avg_unsub_rate"=>nil, "target_sub_rate"=>nil, "open_rate"=>nil, "click_rate"=>nil}.keys  
    end
    
    should "return the list is a List object is passed" do
      assert_equal Chimpactions.list(Chimpactions.available_lists[0]), Chimpactions.available_lists[0]
    end
    
    
  end
  
end
