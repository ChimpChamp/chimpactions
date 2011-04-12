require 'test_helper'
require 'chimpactions/setup'

class SetupTest < ActiveSupport::TestCase

  def run_initializer
    Chimpactions.setup do |config|
      config.mailchimp_api_key = "secret_mailchimp_api_key"
      config.mailchimp_ses_key = "secret_mailchimp_ses_key"
    end
  
  end

  test "setup initializer" do
    setup = Chimpactions::Setup.ensure_initialization
    assert_equal Chimpactions::Setup.message, "Chimpactions::Setup.initialize"
  end
  
  test "Default authorization values should cause initialization failure" do
    setup = Chimpactions::Setup.ensure_initialization
    assert_equal Chimpactions::Setup.ok?, false
  end
  
  test "Default authorization values should create Setup.errors" do
    setup = Chimpactions::Setup.ensure_initialization
    assert_equal Chimpactions::Setup.ok?, false
    assert_equal Chimpactions::Setup.errors[:api_key], "Is the default!"
  end
  
  test "initilizer should set authorization keys" do
    run_initializer
    assert_equal Chimpactions.mailchimp_api_key, "secret_mailchimp_api_key"
    assert_equal Chimpactions.mailchimp_ses_key, "secret_mailchimp_ses_key"
    Chimpactions::Setup.ensure_initialization
    assert_equal Chimpactions::Setup.ok?, true
  end
  
end