require_relative './concerns/slugifiable.rb'

class User < ActiveRecord::Base
  has_many :collections
  has_many :items, through: :collections
  has_secure_password
  
  include Slugifiable::InstanceMethods
  extend Slugifiable::ClassMethods
end