module Chimpactions
class ListNotifier
   def update(chimpactions)
     chimpactions::List.new_socket
   end
end
end
