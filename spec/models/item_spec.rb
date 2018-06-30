require 'spec_helper'

describe "Item" do
  before do
    @fav_foods = Collection.create(:name => "Favorite Foods", :description => "These are all of my favorite foods!")
    @pizza = Item.create(:name => "Pizza", :description => "Best pizza is in NYC", :collection_id => @fav_foods.id)
    @burger = Item.create(:name => "Burger", :description => "In-N-Out is overrated", :collection_id => @fav_foods.id)
    @pad_thai = Item.create(:name => "Pad Thai", :description => "Thai food is great", :collection_id => @fav_foods.id)
  end
  
  it 'has a name and a description' do
    expect(@pizza.name).to eq("Pizza")
    expect(@pizza.description).to eq("Best pizza is in NYC")
    expect(@burger.name).to eq("Burger")
    expect(@burger.description).to eq("In-N-Out is overrated")
  end
  
  it 'can slug the name' do
    expect(@pad_thai.slug).to eq("pad-thai")
  end

  it 'can find an item based on the slug' do
    slug = @pad_thai.slug
    expect(Item.find_by_slug(slug).name).to eq("Pad Thai")
  end
  
  it 'belongs to a collection' do
    expect(@fav_foods.items).to include(@pizza)
    expect(@fav_foods.items).to include(@burger)
  end
    
end