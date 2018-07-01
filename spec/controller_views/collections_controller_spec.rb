require 'spec_helper'

describe CollectionsController do
  
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
      it 'displays a single collection and all of its items with links to item show pages' do
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
        #expect(page.body).to include(robbing_banks.description)
        expect(page.body).to include(laughing.name)
        #expect(page.body).to include(laughing.description)
        expect(page.body).to include("</a>")
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
        expect(page.body).to include('<form')
        expect(page.body).to include('collection[name]')
        expect(page.body).to include('collection[description]')
        expect(page.body).to include('item[name]')
        expect(page.body).to include('Edit collection')
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
      
      it 'does not update collection name or description if those fields are left blank' do
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
        
        expect(allies.name).to eq("Allies")
        expect(allies.description).to eq("These are the heroes I work with and trust with my life.")
        expect(Collection.find_by(:name => "Justice League")).to be(nil)
        expect(page.current_path).to eq("/collections/#{allies.slug}")
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
        
        visit "collections/#{collection2.slug}"
        click_button "Delete this collection"
        expect(page.status_code).to eq(200)
        expect(Collection.find_by(:name => "Allies")).to be_instance_of(Collection)
        expect(page.current_path).to include('/collections')
      end
    end
    
    context 'logged out' do
      it 'does not let a user delete a collection if they are not logged in' do
        collection = Collection.create(:name => "Allies", :description => "These are the heroes I work with and trust with my life.", :user_id => 1)
        visit '/collections/1'
        expect(page.current_path).to eq('/login')
      end
    end
  end
  
end