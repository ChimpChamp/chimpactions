class User < ActiveRecord::Base
  include Chimpactions::Subscriber
  after_save :chimpactions
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
end
