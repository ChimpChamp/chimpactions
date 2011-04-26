require 'test_helper'
require 'chimpactions/setup'

class SetupTest < ActiveSupport::TestCase
  context "With a good initializer" do
    setup do
      Chimpactions.setup do |config|
        config.mailchimp_api_key = "secret_mailchimp_api_key"
        config.mailchimp_ses_key = "secret_mailchimp_ses_key"
        config.merge_map = {
          'FNAME'=> 'first_name',
          'LNAME' => 'last_name',
          'EMAIL' => 'email',
          'FAV_COL' => 'favorite_color'
        }
      end
    end
  
    should "set authorization keys and be ok?" do
      assert_equal Chimpactions.mailchimp_api_key, "secret_mailchimp_api_key"
      assert_equal Chimpactions.mailchimp_ses_key, "secret_mailchimp_ses_key"
      Chimpactions::Setup.ensure_initialization
      assert_equal Chimpactions::Setup.ok?, true
    end
    
    should "fail to connect with a bad API key" do
      assert_equal Chimpactions::Setup.verify, false
    end
    
  end

  context "With no initializer" do 
    setup do
      Chimpactions.setup do |config|
        config.mailchimp_api_key = nil
        config.merge_map = nil
        config.mailchimp_ses_key = nil
      end
    end
  
    should "cause initialization failure" do
      setup = Chimpactions::Setup.ensure_initialization
      assert_equal Chimpactions::Setup.ok?, false
    end
  end
  
  context"With default initializer" do
    setup do
      Chimpactions.setup do |config|
        config.mailchimp_api_key = "your_mailchimp_api_key"
        config.merge_map = {
          'FNAME'=> 'first_name',
          'LNAME' => 'last_name',
          'EMAIL' => 'email'
        }
        config.mailchimp_ses_key = "your_mailchimp_ses_key"
      end
    end

    should "setup initializer" do
      setup = Chimpactions::Setup.ensure_initialization
      assert_equal Chimpactions::Setup.message, "Chimpactions::Setup.initialize"
    end
  
    should "cause initialization failure with defaults" do
      setup = Chimpactions::Setup.ensure_initialization
      assert_equal Chimpactions::Setup.ok?, false
    end
  
    should "create Setup.errors with defaults" do
      setup = Chimpactions::Setup.ensure_initialization
      assert_equal Chimpactions::Setup.ok?, false
      assert_equal Chimpactions::Setup.errors[:api_key], "Is not set!"
    end
  end

end