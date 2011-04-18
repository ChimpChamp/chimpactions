module Chimpactions
  module Exception
    class ArgumentError < StandardError; end
    class SetupError < RuntimeError; end
    class ConnectionError < IOError; end
    class MailChimpError < ConnectionError; end
  end
end