require 'test_helper'

class ChimpactionsControllerTest < ActionController::TestCase
  
  test "truth" do
    assert_kind_of Dummy::Application, Rails.application
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:actions)
    assert_not_nil assigns(:registered)
    assert_not_nil assigns(:ar_actions)
  end
end
