require 'spec_helper'

describe "User" do
  before do
    @user = User.create(username: "The Joker", email: "jokerking50@gmail.com", password: "jokerrules")
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
  
  
end