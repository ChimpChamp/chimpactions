Chimpactions.setup do |config|
  # Your MailChimp API key.
  config.mailchimp_api_key = "your_mailchimp_api_key"
  # Mappings of YOUR MailChimp Merge Variables
  # => This list should include ANY merge variables throughout your MailChimp
  #    account from any and all lists.
  # => Chimpactions will fails gracefully (i.e. not try to send) any varibles
  #    either not set by your model, or not in the particular list.
  # => If your model does not respond_to?('your_models_attribute_or_method')
  #    the merge variable will be skipped (not sent).
  # @format :: {'MAILCHIMP_MERGE_VAR' => 'model_attribute_or_method', 'MAILCHIMP_MERGE_VAR' => 'model_attribute_or_method'}
  config.merge_map = {
    'FNAME'=> 'first_name',
    'LNAME' => 'last_name',
    'EMAIL' => 'email'
  }
  # Your MailChimp SES key.
  config.mailchimp_ses_key = "your_mailchimp_ses_key"
  config.default_double_optin = false #default false Require the user to reply to the MailChimp system before adding to list.
  config.default_send_welcome = true #default true Have MailChimp send the "Welcome" email for the list immediately.
  config.default_email_type =  "html"
end
Chimpactions.for(YourLocalModel)