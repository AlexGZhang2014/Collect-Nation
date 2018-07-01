require_relative './concerns/slugifiable.rb'

class Item < ActiveRecord::Base
  belongs_to :collection
  validates_presence_of :name, :description
  
  def slug
    arr = self.name.split(" ")
    new_arr = arr.collect {|word| word.downcase}
    slug = new_arr.join("-")
  end
  
  extend Slugifiable::ClassMethods
end