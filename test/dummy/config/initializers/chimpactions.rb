Chimpactions.setup do |config|
  # Your MailChimp API key.
  config.mailchimp_api_key = "aefe9dae400a886bf13ac7eee94e7528-us2"
  # Mappings of YOUR MailChimp Merge Variables
  # => This list should include ANY merge variables throughout your MailChimp
  #    account from any and all lists.
  # => Chimpactions will fails gracefully (i.e. not try to send) any varibles
  #    either not set by your model, or not in the particular list.
  # => If your model does not respond_to?('your_models_attribute_or_method')
  #    the merge variable will be skipped (not sent).
  # @format :: {'MAILCHIMP_CONSTANT' => 'your_models_attribute_or_method'}
  config.merge_map = {
    'FNAME'=> 'first_name',
    'LNAME' => 'last_name',
    'EMAIL' => 'email',
    'FAVORITE_COLOR' => 'favorite_color'
  }
  # Your MailChimp SES key.
  config.mailchimp_ses_key = "0987654321"
end
Chimpactions.for(User)