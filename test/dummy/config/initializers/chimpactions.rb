Chimpactions.setup do |config|
  # Your MailChimp API key.
  config.mailchimp_api_key = "aefe9dae400a886bf13ac7eee94e7528-us2"
  config.merge_map = {
    'FNAME'=> 'first_name',
    'LNAME' => 'last_name',
    'EMAIL' => 'email',
    'FAV_COL' => 'favorite_color'
  }
  # Your MailChimp SES key.
  config.mailchimp_ses_key = "0987654321"
end
Chimpactions.for(User)