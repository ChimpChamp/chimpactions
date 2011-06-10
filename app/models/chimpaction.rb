require "chimpactions"

  class ResponseValidator < ActiveModel::Validator
    def validate(record)
       k =  Kernel.const_get(Chimpactions::registered_class.to_s.capitalize).new
      if k.respond_to?(record.action) != true
        record.errors[:action] << "- '#{record.action}' is not a method of #{k.class.name} !"
      end
      if k.respond_to?(record.whenn) != true
        record.errors[:whenn] << "- '#{record.whenn}' is not a method of #{k.class.name} !"
      end
    end
  end

# ActiveRecord 'wrapper' for Chimpactions::Action to provide non-yml peristence & customization
 class Chimpaction < ActiveRecord::Base
   validates_presence_of :list, :action, :whenn, :is, :value
   validates_with ResponseValidator
 end