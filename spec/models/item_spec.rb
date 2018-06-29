require 'spec_helper'

describe "Item" do
  before do
    @fav_foods = Collection.create(:name => "Favorite Foods", :description => "These are all of my favorite foods!")
    @pizza = Item.create(:name => "Pizza", :description => "Best pizza is in NYC")
    @burger = Item.create(:name => "Burger", :description => "In-N-Out is overrated")
  end
  
  it 'has a name and a description' do
    expect(@pizza.name).to eq("Pizza")
    expect(@pizza.description).to eq("Best pizza is in NYC")
    expect(@pizza.description).to eq("In-N-Out is overrated")
    expect(@burger.name).to eq("Burger")
  end
  
  it 'belongs to a collection' do
    @fav_foods.items << @pizza
    @fav_foods.items << @burger
    expect(@fav_foods.items).to include(@pizza)
    expect(@fav_foods.items).to include(@burger)
  end
    
end