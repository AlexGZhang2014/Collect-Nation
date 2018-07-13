require 'rack-flash'

class CollectionsController < ApplicationController
  use Rack::Flash
  
  get '/collections' do
    if logged_in?
      @collections = Collection.all
      erb :'collections/index'
    else
      flash[:message] = "You must log in to view the homepage."
      redirect to '/login'
    end
  end
  
  get '/collections/new' do
    if logged_in?
      erb :'collections/new'
    else
      flash[:message] = "Sorry, but you must be logged in to create a new collection."
      redirect to '/login'
    end
  end
  
  post '/collections' do
    if !params[:collection][:name].empty? && !params[:collection][:description].empty? && !params[:item][:name].empty? && !params[:item][:description].empty?
      @collection = Collection.new(params[:collection])
      #@item = Item.new(params[:item])
    #end
    #if @collection.save && @item.save
      @collection.user = current_user
      @collection.items << Item.create(params[:item])
      @collection.save
      flash[:message] = "Collection and item successfully created."
      redirect to "/collections/#{@collection.slug}"
    else
      flash[:message] = "You must fill in all fields to continue."
      redirect to "/collections/new"
    end
  end
  
  get '/collections/:slug' do
    if logged_in?
      @collection = Collection.find_by_slug(params[:slug])
      erb :'collections/show'
    else
      flash[:message] = "Sorry, but you cannot view this collection without logging in."
      redirect to '/login'
    end
  end
  
  get '/collections/:slug/edit' do
    @collection = Collection.find_by_slug(params[:slug])
    if logged_in? && current_user.id == @collection.user_id
      erb :'collections/edit'
    elsif logged_in?
      flash[:message] = "Sorry, but you cannot edit another user's collection."
      redirect to "/collections/#{@collection.slug}"
    else
      flash[:message] = "Sorry, but you need to log in first before editing."
      redirect to "/login"
    end
  end
  
  patch '/collections/:slug' do
    @collection = Collection.find_by_slug(params[:slug])
    #@item = Item.new(params[:slug])
    #if !params[:item][:name].empty? && !params[:item][:description].empty?
    #if @collection.save && @item.save
      #@collection.items << Item.create(params[:item])
      #@collection.save
      #flash[:message] = "Item successfully created."
    #end
    if !params[:collection][:name].empty? && !params[:collection][:description].empty?
      @collection.update(name: params[:collection][:name], description: params[:collection][:description])
        flash[:message] = "Collection successfully updated."
        #redirect to "/collections/#{@collection.slug}"
    end
    if !params[:item][:name].empty? && !params[:item][:description].empty?
      @collection.items << Item.create(params[:item])
      #@collection.update(name: params[:collection][:name], description: params[:collection][:description])
      flash[:message] = "Collection successfully updated with new item."
    end
    redirect to "/collections/#{@collection.slug}"
    
    
  #   if !params[:collection][:name].empty? && !params[:collection][:description].empty? && !params[:item][:name].empty? && !params[:item][:description].empty?
  #     @collection.items << Item.create(params[:item])
  #     @collection.update(name: params[:collection][:name], description: params[:collection][:description])
  #     flash[:message] = "Collection successfully updated with new item."
  #     redirect to "/collections/#{@collection.slug}"
  #   elsif !params[:collection][:name].empty? && params[:collection][:description].empty? && !params[:item][:name].empty? && !params[:item][:description].empty?
  #     @collection.items << Item.create(params[:item])
  #     @collection.update(name: params[:collection][:name])
  #     flash[:message] = "Collection successfully updated with new item."
  #     redirect to "/collections/#{@collection.slug}"
  #   elsif !params[:collection][:description].empty? && params[:collection][:name].empty? && !params[:item][:name].empty? && !params[:item][:description].empty?
  #     @collection.items << Item.create(params[:item])
  #     @collection.update(description: params[:collection][:description])
  #     flash[:message] = "Collection successfully updated with new item."
  #     redirect to "/collections/#{@collection.slug}"
  #   elsif !params[:collection][:name].empty? && !params[:collection][:description].empty?
  #     @collection.update(name: params[:collection][:name], description: params[:collection][:description])
  #     flash[:message] = "Collection successfully updated."
  #     redirect to "/collections/#{@collection.slug}"
  #   elsif !params[:collection][:name].empty? && params[:collection][:description].empty?
  #     @collection.update(name: params[:collection][:name])
  #     flash[:message] = "Collection successfully updated."
  #     redirect to "/collections/#{@collection.slug}"
  #   elsif !params[:collection][:description].empty? && params[:collection][:name].empty?
  #     @collection.update(description: params[:collection][:description])
  #     flash[:message] = "Collection successfully updated."
  #     redirect to "/collections/#{@collection.slug}"
  #   elsif !params[:item][:name].empty? && !params[:item][:description].empty?
  #     @collection.items << Item.create(params[:item])
  #     @collection.save
  #     flash[:message] = "Item successfully created."
  #     redirect to "/collections/#{@collection.slug}"
  #   else
  #     flash[:message] = "Collection not updated."
  #     redirect to "/collections/#{@collection.slug}"
  #   end
  end
  
  delete '/collections/:slug/delete' do
    @collection = Collection.find_by_slug(params[:slug])
    if logged_in? && current_user.id == @collection.user_id
      @collection.destroy
      flash[:message] = "Collection deleted."
      redirect to '/collections'
    elsif logged_in?
      flash[:message] = "Sorry, but you cannot delete another user's collection."
      redirect to "/collections/#{@collection.slug}"
    else
      flash[:message] = "Sorry, but you must first log in to delete a collection."
      redirect to '/login'
    end
  end
end