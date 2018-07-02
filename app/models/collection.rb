require_relative './concerns/slugifiable.rb'

class Collection < ActiveRecord::Base
  belongs_to :user
  has_many :items
  validates_presence_of :name, :description
  
  def slug
    self.name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end
  
  extend Slugifiable::ClassMethods
end