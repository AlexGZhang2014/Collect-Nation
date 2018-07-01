require_relative './concerns/slugifiable.rb'

class Collection < ActiveRecord::Base
  belongs_to :user
  has_many :items
  validates_presence_of :name, :description
  
  def slug
    arr = self.name.split(" ")
    new_arr = arr.collect {|word| word.downcase}
    slug = new_arr.join("-")
  end
  
  extend Slugifiable::ClassMethods
end