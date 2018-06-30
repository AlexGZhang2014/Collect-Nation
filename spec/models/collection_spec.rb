require 'spec_helper'

describe "Collection" do
  before do
    @user = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
    @fav_activities = Collection.create(:name => "Favorite Activities", :description => "These are all the things I enjoy doing the most, even if some of them are illegal. But I'm the Joker, so what did you expect?", :user_id => @user.id)
    @fav_foods = Collection.create(:name => "Favorite Foods", :description => "These are all of my favorite foods!", :user_id => @user.id)
    @robbing_banks = Item.create(:name => "Robbing Banks", :description => "I love money!", :collection_id => @fav_activities.id)
    @laughing = Item.create(:name => "Laughing Maniacally", :description => "Who doesn't love laughing? One day I'll make Batman laugh!", :collection_id => @fav_activities.id)
    @pizza = Item.create(:name => "Pizza", :description => "Best pizza is in NYC", :collection_id => @fav_foods.id)
    @burger = Item.create(:name => "Burger", :description => "In-N-Out is overrated", :collection_id => @fav_foods.id)
  end
  
  it 'has a name and a description' do
    expect(@fav_activities.name).to eq("Favorite Activities")
    expect(@fav_activities.description).to eq("These are all the things I enjoy doing the most, even if some of them are illegal. But I'm the Joker, so what did you expect?")
    expect(@fav_foods.name).to eq("Favorite Foods")
    expect(@fav_foods.description).to eq("These are all of my favorite foods!")
  end
  
  it 'can slug the name' do
    expect(@fav_activities.slug).to eq("favorite-activities")
    expect(@fav_foods.slug).to eq("favorite-foods")
  end

  it 'can find a collection based on the slug' do
    slug1 = @fav_activities.slug
    expect(Collection.find_by_slug(slug1).name).to eq("Favorite Activities")
    slug2 = @fav_foods.slug
    expect(Collection.find_by_slug(slug2).name).to eq("Favorite Foods")
  end
  
  it 'belongs to a user' do
    expect(@user.collections).to include(@fav_activities)
    expect(@user.collections).to include(@fav_foods)
  end
  
  it 'can have many items' do
    expect(@fav_activities.items).to include(@robbing_banks)
    expect(@fav_activities.items).to include(@laughing)
    expect(@fav_foods.items).to include(@pizza)
    expect(@fav_foods.items).to include(@burger)
  end
end