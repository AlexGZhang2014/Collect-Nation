require_relative './concerns/slugifiable.rb'

class Item < ActiveRecord::Base
  belongs_to :collection
  validates_presence_of :name, :description
  
  def slug
    self.name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end
  
  extend Slugifiable::ClassMethods
end