class Item < ActiveRecord::Base
  belongs_to :collection
  
  def slug
    arr = self.name.split(" ")
    new_arr = arr.collect {|word| word.downcase}
    slug = new_arr.join("-")
  end
  
  extend Slugifiable::ClassMethods
end