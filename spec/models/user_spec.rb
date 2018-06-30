require 'spec_helper'

describe "User" do
  before do
    @user = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
    @fav_activities = Collection.create(:name => "Favorite Activities", :description => "These are all the things I enjoy doing the most, even if some of them are illegal. But I'm the Joker, so what did you expect?", :user_id => @user.id)
    @fav_foods = Collection.create(:name => "Favorite Foods", :description => "These are all of my favorite foods!", :user_id => @user.id)
    @robbing_banks = Item.create(:name => "Robbing Banks", :description => "I love money!", :collection_id => @fav_activities.id)
    @laughing = Item.create(:name => "Laughing Maniacally", :description => "Who doesn't love laughing? One day I'll make Batman laugh!", :collection_id => @fav_activities.id)
    @pizza = Item.create(:name => "Pizza", :description => "Best pizza is in NYC", :collection_id => @fav_foods.id)
    @burger = Item.create(:name => "Burger", :description => "In-N-Out is overrated", :collection_id => @fav_foods.id)
  end
  
  it 'has a username' do
    expect(@user.username).to eq("The Joker")
  end
  
  it 'has an email' do
    expect(@user.email).to eq("jokerking50@gmail.com")
  end
  
  it 'can slug the username' do
    expect(@user.slug).to eq("the-joker")
  end

  it 'can find a user based on the slug' do
    slug = @user.slug
    expect(User.find_by_slug(slug).username).to eq("The Joker")
  end

  it 'has a secure password' do
    expect(@user.authenticate("batmansucks")).to eq(false)
    expect(@user.authenticate("jokerrules")).to eq(@user)
  end
  
  it 'can have many collections' do
    expect(@user.collections).to include(@fav_activities)
    expect(@user.collections).to include(@fav_foods)
  end
  
  it 'can have many items through collections' do
    expect(@user.items).to include(@robbing_banks)
    expect(@user.items).to include(@laughing)
    expect(@user.items).to include(@pizza)
    expect(@user.items).to include(@burger)
  end
  
end