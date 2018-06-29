require 'spec_helper'

describe "Item" do
  before do
    @fav_activities = Collection.create(:name => "Favorite Activities")
    @fav_foods = Collection.create(:name => "Favorite Foods")
    @robbing_banks = Item.create(:name => "Robbing Banks")
    @laughing = Item.create(:name => "Laughing Maniacally")
    @pizza = Item.create(:name => "Pizza")
    @burger = Item.create(:name => "Burger")
  end
end