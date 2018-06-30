require 'spec_helper'

describe ApplicationController do

  describe "Homepage" do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome to Collect Nation!")
    end
  end
  
  describe "Signup Page" do
    it 'loads the signup page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end
    
    it 'directs the user to the collections index page after signing up' do
      params = {
        :username => "The Joker",
        :email => "jokerking50@gmail.com"
        :password => "jokerrules"
      }
      post '/signup', params
      expect(last_response.location).to include("/collections")
    end
    
    it 'does not let a user sign up without a username' do
      params = {
        :username => "",
        :email => "jokerking50@gmail.com"
        :password => "jokerrules"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end
    
    it 'does not let a user sign up without an email' do
      params = {
        :username => "The Joker",
        :email => ""
        :password => "jokerrules"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end
    
    it 'does not let a user sign up without a password' do
      params = {
        :username => "The Joker",
        :email => "jokerking50@gmail.com"
        :password => ""
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end
    
    it 'creates a new user and logs them in on valid submission and does not let a logged in user view the signup page' do
      params = {
        :username => "The Joker",
        :email => "jokerking50@gmail.com"
        :password => "jokerrules"
      }
      post '/signup', params
      get '/signup'
      expect(last_response.location).to include('/collections')
    end
  end
  
  describe "login" do
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end
    
    it 'loads the collections index page after login' do
      user = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
      params = {
        :username => "The Joker"
        :password => "jokerrules"
      }
      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome, ")
    end
    
    it 'does not let the user view the login page if they are already logged in' do
      user = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
      params = {
        :username => "The Joker"
        :password => "jokerrules"
      }
      post '/login', params
      get '/login'
      expect(last_response.location).to include("/collections")
    end
  end
  
  describe "logout" do
    it 'lets a user log out if they are already logged in' do
      user = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
      params = {
        :username => "The Joker"
        :password => "jokerrules"
      }
      post '/login', params
      get '/logout'
      expect(last_response.location).to include('/login')
    end
    
    it 'does not let a user logout if they are not logged in' do
      get '/logout'
      expect(last_response.location).to include('/')
    end
    
    it 'does not load /collections if the user is not logged in' do
      get '/collections'
      expect(last_response.location).to include('/login')
    end
    
    it 'does load /collections if the user is logged in' do
      user = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
      visit '/login'
      fill_in(:username, :with => "The Joker")
      fill_in(:password, :with => "jokerrules")
      click_button 'Log In'
      expect(page.current_path).to eq('/collections')
    end
  end
  
  describe 'user show page' do
    it 'shows all collections for a single user' do
      user = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
      fav_activities = Collection.create(:name => "Favorite Activities", :description => "These are all the things I enjoy doing the most, even if some of them are illegal. But I'm the Joker, so what did you expect?")
      fav_foods = Collection.create(:name => "Favorite Foods", :description => "These are all of my favorite foods!")
      get "/users/#{user.slug}"
      
      expect(last_response.body).to include("Favorite Activities")
      expect(last_response.body).to include("Favorite Foods")
    end
    
    it 'displays links to the show page for each collection' do
      user = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
      fav_activities = Collection.create(:name => "Favorite Activities", :description => "These are all the things I enjoy doing the most, even if some of them are illegal. But I'm the Joker, so what did you expect?")
      fav_foods = Collection.create(:name => "Favorite Foods", :description => "These are all of my favorite foods!")
      get "/users/#{user.slug}"
      
      expect(last_response.body).to include('</a>')
      expect(last_response.body).to include("/collections/#{collection.slug}")
    end
  end
  
  describe 'collection index action' do
    context 'logged in' do
      it 'lets a user view the index of collections if they are logged in' do
        user1 = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
        fav_activities = Collection.create(:name => "Favorite Activities", :description => "These are all the things I enjoy doing the most, even if some of them are illegal. But I'm the Joker, so what did you expect?", :user_id => user1.id)
        user2 = User.create(:username => "The Batman", :email => "thebatman100@gmail.com", :password => "darknightrises")
        rogues_gallery = Collection.create(:name => "Rogues Gallery", :description => "A list of all the villains I have fought against. Each entry has their strengths, weaknesses, and personality traits.", :user_id => user2.id)
        
        visit '/login'
        fill_in(:username, :with => "The Batman")
        fill_in(:username, :with => "darknightrises")
        click_button 'Log In'
        
        visit '/collections'
        expect(page.body).to include(fav_activities.name)
        expect(page.body).to include(rogues_gallery.name)
      end
    end
      
    context 'logged out' do
      it 'does not let a user view the index of collections if they are not logged in' do
        get '/collections'
        expect(last_response.location).to include('/login')
      end
    end
  end
  
  describe 'collection new action' do
    context 'logged in' do
      it 'lets a user view the new collection form if they are logged in' do
        user = User.create(:username => "The Batman", :email => "thebatman100@gmail.com", :password => "darknightrises")
        
        visit '/login'
        fill_in(:username, :with => "The Batman")
        fill_in(:username, :with => "darknightrises")
        click_button 'Log In'
        
        visit '/collections/new'
        expect(page.status_code).to eq(200)
        expect(page.body).to include('<form')
        expect(page.body).to include('collection[name]')
        expect(page.body).to include('collection[description]')
        expect(page.body).to include('item[name]')
        expect(page.body).to include('item[description]')
        
      end
      
      it 'lets a user create a new collection with 1 new item if they are logged in' do
        user = User.create(:username => "The Batman", :email => "thebatman100@gmail.com", :password => "darknightrises")
        
        visit '/login'
        fill_in(:username, :with => "The Batman")
        fill_in(:username, :with => "darknightrises")
        click_button 'Log In'
        
        visit '/collections/new'
        fill_in(:collection_name, :with => "Allies")
        fill_in(:collection_description, :with => "These are the heroes I work with and trust with my life.")
        fill_in(:item_name, :with => "Superman")
        fill_in(:item_description, :with => "The strongest Kryptonian I know")
        click_button 'Create new collection'
        
        user = User.find_by(:username => "The Batman")
        collection = Collection.find_by(:collection_name => "Allies")
        item = Item.find_by(:item_name => "Superman")
        expect(collection).to be_instance_of(Collection)
        expect(collection.user_id).to eq(user.id)
        expect(item).to be_instance_of(Item)
        expect(item.collection_id).to eq(collection.id)
        expect(page.status_code).to eq(200)
      end
      
      it 'does not let a user create a collection for another user' do
        user1 = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
        user2 = User.create(:username => "The Batman", :email => "thebatman100@gmail.com", :password => "darknightrises")
        
        visit '/login'
        fill_in(:username, :with => "The Batman")
        fill_in(:username, :with => "darknightrises")
        click_button 'Log In'
        
        visit '/collections/new'
        fill_in(:collection_name, :with => "Allies")
        fill_in(:collection_description, :with => "These are the heroes I work with and trust with my life.")
        fill_in(:item_name, :with => "Superman")
        fill_in(:item_description, :with => "The strongest Kryptonian I know")
        click_button 'Create new collection'
        
        joker = User.find_by(:id => user1.id)
        batman = User.find_by(:id => user2.id)
        collection = Collection.find_by(:collection_name => "Allies")
        expect(collection).to be_instance_of(Collection)
        expect(collection.user_id).to eq(batman.id)
        expect(collection.user_id).not_to eq(joker.id)
      end
      
      it 'does not let a user create an empty collection' do
        user = User.create(:username => "The Batman", :email => "thebatman100@gmail.com", :password => "darknightrises")
        
        visit '/login'
        fill_in(:username, :with => "The Batman")
        fill_in(:username, :with => "darknightrises")
        click_button 'Log In'
        
        visit '/collections/new'
        fill_in(:collection_name, :with => "")
        fill_in(:collection_description, :with => "")
        fill_in(:item_name, :with => "")
        fill_in(:item_description, :with => "")
        click_button 'Create new collection'
        
        expect(Collection.find_by(:collection_name => "")).to eq(nil)
        expect(Collection.find_by(:collection_description => "")).to eq(nil)
        expect(Collection.find_by(:item_name => "")).to eq(nil)
        expect(Collection.find_by(:item_description => "")).to eq(nil)
        expect(page.current_path).to eq('/collections/new')
      end
    end
    
    context 'logged out' do
      it 'does not let a user view the new collection form if they are not logged in' do
        get '/collection/new'
        expect(last_response.location).to eq('/login')
      end
    end
  end
  
  describe 'collection show action' do
    context 'logged in' do
      it 'displays a single collection and all of its items' do
        user = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
        fav_activities = Collection.create(:name => "Favorite Activities", :description => "These are all the things I enjoy doing the most, even if some of them are illegal. But I'm the Joker, so what did you expect?", :user_id => user.id)
        robbing_banks = Item.create(:name => "Robbing Banks", :description => "I love money!", :collection_id => fav_activities.id)
        laughing = Item.create(:name => "Laughing Maniacally", :description => "Who doesn't love laughing? One day I'll make Batman laugh!", :collection_id => fav_activities.id)
        
        visit '/login'
        fill_in(:username, :with => "The Joker")
        fill_in(:username, :with => "jokerrules")
        click_button 'Log In'
        
        visit "/collections/#{fav_activities.slug}"
        expect(page.status_code).to eq(200)
        expect(page.body).to include("Delete this collection")
        expect(page.body).to include("Edit this collection")
        expect(page.body).to include(fav_activities.name)
        expect(page.body).to include(fav_activities.description)
        expect(page.body).to include(robbing_banks.name)
        expect(page.body).to include(robbing_banks.description)
        expect(page.body).to include(laughing.name)
        expect(page.body).to include(laughing.description)
      end
    end
    
    context 'logged out' do
      it 'does not let a user view an individual collection' do
        user = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
        fav_activities = Collection.create(:name => "Favorite Activities", :description => "These are all the things I enjoy doing the most, even if some of them are illegal. But I'm the Joker, so what did you expect?", :user_id => user.id)
        robbing_banks = Item.create(:name => "Robbing Banks", :description => "I love money!", :collection_id => fav_activities.id)
        laughing = Item.create(:name => "Laughing Maniacally", :description => "Who doesn't love laughing? One day I'll make Batman laugh!", :collection_id => fav_activities.id)
        get "/collections/#{fav_activities.slug}"
        expect(last_response.location).to include('/login')
      end
    end
  end
  
  describe 'collection edit action' do
    context 'logged in' do
      it 'lets a user view the collection edit form if they are logged in' do
        user = User.create(:username => "The Batman", :email => "thebatman100@gmail.com", :password => "darknightrises")
        collection = Collection.create(:name => "Allies", :description => "These are the heroes I work with and trust with my life.", :user_id => user.id)
        item1 = Item.create(:name => "Superman", :description => "The strongest Kryptonian I know", :collection_id => collection.id)
        
        visit '/login'
        fill_in(:username, :with => "The Batman")
        fill_in(:username, :with => "darknightrises")
        click_button 'Log In'
        
        visit "/collections/#{collection.slug}/edit"
        expect(page.status_code).to eq(200)
        expect(page.body).to include(collection.name)
        expect(page.body).to include(collection.description)
        expect(page.body).to include(item.name)
        expect(page.body).to include(item.description)
        expect(page.body).to include('<form')
        expect(page.body).to include('collection[name]')
        expect(page.body).to include('collection[description]')
        expect(page.body).to include('item[name]')
        expect(page.body).to include('item[description]')
        expect(page.body).to include('Edit this item')
        #We need to implement an edit button for an item such that when we click edit item, it will do the GET item/edit route, and then we'll be redirected back to the collection/edit page after editing the item.
        expect(page.body).to include('Delete this item')
      end
      
      it 'does not let a user edit a collection they did not create' do
        user1 = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
        collection1 = Collection.create(:name => "Favorite Activities", :description => "These are all the things I enjoy doing the most, even if some of them are illegal. But I'm the Joker, so what did you expect?", :user_id => user1.id)
        item1 = Item.create(:name => "Robbing Banks", :description => "I love money!", :collection_id => collection1.id)
        user2 = User.create(:username => "The Batman", :email => "thebatman100@gmail.com", :password => "darknightrises")
        collection2 = Collection.create(:name => "Allies", :description => "These are the heroes I work with and trust with my life.", :user_id => user2.id)
        item2 = Item.create(:name => "Superman", :description => "The strongest Kryptonian I know", :collection_id => collection2.id)
        
        visit '/login'
        fill_in(:username, :with => "The Joker")
        fill_in(:username, :with => "jokerrules")
        click_button 'Log In'
        
        visit "/collections/#{collection2.slug}/edit"
        expect(page.current_path).to include('/collections')
      end
      
      it 'lets a user edit their own collection if they are logged in' do
        batman = User.create(:username => "The Batman", :email => "thebatman100@gmail.com", :password => "darknightrises")
        allies = Collection.create(:name => "Allies", :description => "These are the heroes I work with and trust with my life.", :user_id => batman.id)
        superman = Item.create(:name => "Superman", :description => "The strongest Kryptonian I know", :collection_id => allies.id)
        
        visit '/login'
        fill_in(:username, :with => "The Batman")
        fill_in(:username, :with => "darknightrises")
        click_button 'Log In'
        
        visit "/collections/#{allies.slug}/edit"
        fill_in(:collection_name, :with => "Justice League")
        fill_in(:collection_description, :with => "The greatest team of superheroes ever")
        fill_in(:item_name, :with => "Wonder Woman")
        fill_in(:item_description, :with => "The powerful Amazon princess")
        click_button 'Edit collection'
        
        expect(Collection.find_by(:name => "Justice League")).to be_instance_of(Collection)
        expect(Collection.find_by(:name => "Allies")).to eq(nil)
        expect(page.status_code).to eq(200)
      end
      
      it 'does not let a user edit a collection with blank content' do
        batman = User.create(:username => "The Batman", :email => "thebatman100@gmail.com", :password => "darknightrises")
        allies = Collection.create(:name => "Allies", :description => "These are the heroes I work with and trust with my life.", :user_id => batman.id)
        superman = Item.create(:name => "Superman", :description => "The strongest Kryptonian I know", :collection_id => allies.id)
        
        visit '/login'
        fill_in(:username, :with => "The Batman")
        fill_in(:username, :with => "darknightrises")
        click_button 'Log In'
        
        visit "/collections/#{allies.slug}/edit"
        fill_in(:collection_name, :with => "")
        fill_in(:collection_description, :with => "")
        click_button 'Edit collection'
        
        expect(Collection.find_by(:name => "Justice League")).to be(nil)
        expect(page.current_path).to eq("/collections/#{collections/allies.slug/edit}")
      end
    end
    
    context 'logged out' do
      it 'does not load the edit form, but rather redirects to the login page' do
        get '/collections/1/edit'
        expect(last_response.location).to include('/login')
      end
    end
  end
  
  describe 'collection delete action' do
    context 'logged in' do
      it 'lets a user delete their own collection if they are logged in' do
        user = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
        fav_foods = Collection.create(:name => "Favorite Foods", :description => "These are all of my favorite foods!", :user_id => user.id)
        pizza = Item.create(:name => "Pizza", :description => "Best pizza is in NYC", :collection_id => fav_foods.id)
        burger = Item.create(:name => "Burger", :description => "In-N-Out is overrated", :collection_id => fav_foods.id)
        
        visit '/login'
        fill_in(:username, :with => "The Joker")
        fill_in(:username, :with => "jokerrules")
        click_button 'Log In'
        
        visit "/collections/#{fav_foods.slug}"
        click_button "Delete this collection"
        expect(page.status_code).to eq(200)
        expect(Collection.find_by(:name => "Favorite Foods")).to eq(nil)
      end
      
      it 'does not let a user delete a collection they did not create' do
        user1 = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
        collection1 = Collection.create(:name => "Favorite Activities", :description => "These are all the things I enjoy doing the most, even if some of them are illegal. But I'm the Joker, so what did you expect?", :user_id => user1.id)
        item1 = Item.create(:name => "Robbing Banks", :description => "I love money!", :collection_id => collection1.id)
        user2 = User.create(:username => "The Batman", :email => "thebatman100@gmail.com", :password => "darknightrises")
        collection2 = Collection.create(:name => "Allies", :description => "These are the heroes I work with and trust with my life.", :user_id => user2.id)
        item2 = Item.create(:name => "Superman", :description => "The strongest Kryptonian I know", :collection_id => collection2.id)
        
        visit '/login'
        fill_in(:username, :with => "The Joker")
        fill_in(:username, :with => "jokerrules")
        click_button 'Log In'
      end
    end
  end
  
end