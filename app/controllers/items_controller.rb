require 'rack-flash'

class ItemsController < ApplicationController
  get '/items/:slug' do
    if logged_in?
      @item = Item.find_by_slug(params[:slug])
      erb :'items/show'
    else
      flash[:message] = "Sorry, but you must be logged in to view this item."
      redirect to '/login'
    end
  end
  
  get '/items/:slug/edit' do
    @item = Item.find_by_slug(params[:slug])
    if logged_in? && current_user.id == @item.collection.user.id
      erb :'items/edit'
    elsif logged_in?
      flash[:message] = "Sorry, but you cannot edit another user's item."
      redirect to "/collections"
    else
      flash[:message] = "You must log in before editing an item."
      redirect to '/login'
    end
  end
  
  patch '/items/:slug' do
    @item = Item.find_by_slug(params[:slug])
    if !params[:item][:name].empty? && !params[:item][:description].empty?
      @item.update(name: params[:item][:name], description: params[:item][:description])
    else
      flash[:message] = "You must fill in all fields to continue."
      redirect to "/items/#{@item.slug}/edit"
    end
  end
  
  delete '/items/:slug/delete' do
    @item = Item.find_by_slug(params[:slug])
    if logged_in? && current_user.id == @item.collection.user.id
      @item.destroy
      flash[:message] = "Item deleted."
      redirect to "/collections/#{@item.collection.slug}/edit"
    else
      flash[:message] = "You must log in before deleting an item."
      redirect to '/login'
    end
  end
  
end