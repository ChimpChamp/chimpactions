module Chimpactions
    # A Chimpactions specific ArgumentError.
    class ArgumentError < ArgumentError; end
    # For an empty result from a MailChimp request.
    class NotFoundError < StandardError; end
    # A setting Chimpactions needs is missing or malformed. 
    class SetupError < RuntimeError; end
    # Low level error in the MailChimp connection (gibbon).
    class ConnectionError < IOError; end
    # Bad API key.
    class AuthError < ConnectionError; end
    # An error from the MAilChimp API
    class MailChimpError < ConnectionError; end
end