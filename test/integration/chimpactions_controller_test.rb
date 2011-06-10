require 'test_helper'
class ChimpactionsControllerTest < ActionController::TestCase
  
  setup do  
    action_hash
  end
  
  test "truth" do
    assert_kind_of Dummy::Application, Rails.application
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:actions)
    assert_not_nil assigns(:registered)
    assert_not_nil assigns(:actions)
    assert_template :index
  end
  
  test "show new form" do
    get :new
    assert_template :new
  end
  
  test "should add new chimpaction" do
    count  = Chimpaction.count
    put :create, :chimpaction => @action_hash
    assert_equal count+1, Chimpaction.count
  end
  
  test "should successfully edit" do
    Chimpaction.create(@action_hash)
    get :edit, :id => Chimpaction.last.id
    assert_template :edit
    assert_template '_form'
    put :update, :id => Chimpaction.last.id, :chimpaction => @action_hash
    assert_equal "Chimpaction was successfully updated.", flash[:notice]
  end 
  
  test "should show edit & errors on bad edit" do
    Chimpaction.create(@action_hash)
    bad_data = @action_hash
    bad_data[:whenn] = 'not_a_method'
    put :update, :id => Chimpaction.last.id, :chimpaction => bad_data
    assert_template :edit
    assert_template '_form'
    assert_template '_errors'
  end 
  
  test "should show errors on bad create" do
    bad_data = @action_hash
    bad_data[:whenn] = 'not_a_method'
    post :create, :chimpaction => bad_data
    assert_template '_errors'
  end
  
  test "should destroy the record" do    
    Chimpaction.create(@action_hash)
    count  = Chimpaction.count
    delete :destroy, :id => Chimpaction.last.id
    assert_equal count-1, Chimpaction.count
  end
  
  
end
