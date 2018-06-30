require 'spec_helper'

describe ItemsController do
  
  describe 'item edit action' do
    context 'logged in' do
      it 'lets a user view the item edit form after clicking the edit button on the collection show page if they are logged in' do
        user = User.create(:username => "The Batman", :email => "thebatman100@gmail.com", :password => "darknightrises")
        collection = Collection.create(:name => "Allies", :description => "These are the heroes I work with and trust with my life.", :user_id => user.id)
        item = Item.create(:name => "Superman", :description => "The strongest Kryptonian I know", :collection_id => collection.id)
        
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
        
        click_button 'Edit this item'
        visit "/items/#{item.slug}/edit"
        expect(page.status_code).to eq(200)
        expect(page.body).to include(item.name)
        expect(page.body).to include(item.description)
        expect(page.body).to include('<form')
        expect(page.body).to include('item[name]')
        expect(page.body).to include('item[description]')
        expect(page.body).to include('Edit this item')
      end
      
      it 'does not let a user edit an item they did not create' do
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
      
      it 'lets a user edit their own item if they are logged in' do
        batman = User.create(:username => "The Batman", :email => "thebatman100@gmail.com", :password => "darknightrises")
        allies = Collection.create(:name => "Allies", :description => "These are the heroes I work with and trust with my life.", :user_id => batman.id)
        superman = Item.create(:name => "Superman", :description => "The strongest Kryptonian I know", :collection_id => allies.id)
        
        visit '/login'
        fill_in(:username, :with => "The Batman")
        fill_in(:username, :with => "darknightrises")
        click_button 'Log In'
        
        visit "/collections/#{allies.slug}/edit"
        click_button 'Edit this item'
        
        visit "/items/#{superman.slug}/edit"
        fill_in(:item_name, :with => "Wonder Woman")
        fill_in(:item_description, :with => "The powerful Amazon princess")
        click_button 'Edit item'
        
        expect(Item.find_by(:name => "Wonder Woman")).to be_instance_of(Item)
        expect(Item.find_by(:name => "Superman")).to eq(nil)
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