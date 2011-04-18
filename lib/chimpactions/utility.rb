module Chimpactions
  module Utility
    # Convenience method for accessing MailChimp data arrays
    # as class attributes.
    # ex. => List.id instead of List['id']
    def method_missing(m, *args)
      @raw.keys.include?(m.to_s) ? @raw[m.to_s] : super
    end
  end
end