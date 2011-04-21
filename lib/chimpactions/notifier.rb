module Chimpactions
# Notifier for telling the List objects that Chimpactions is using a new connection.
class ListNotifier
  # Notify the List class that we havea new connection to MailChimp
   def update(chimpactions)
     chimpactions::List.new_socket
   end
end
end
