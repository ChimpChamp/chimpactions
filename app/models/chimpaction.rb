require "chimpactions"

  class ResponseValidator < ActiveModel::Validator
    def validate(record)
       k =  Kernel.const_get(Chimpactions::registered_class.to_s.capitalize).new
      if k.respond_to?(record.action) != true
        record.errors[:base] << "The Record could not be saved."
        record.errors[:action] << "#{k.class.name} must respond_to? action (#{record.action})"
      end
    end
  end

 class Chimpaction < ActiveRecord::Base
  validates_with ResponseValidator
 end