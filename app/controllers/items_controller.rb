class ItemsController < ApplicationController
  get '/items/:slug' do
    if logged_in?
      @item = Item.find_by_slug(params[:slug])
      erb :'items/show'
    else
      redirect to '/login'
    end
  end
  
  get '/items/:slug/edit' do
    @item = Item.find_by_slug(params[:slug])
    if logged_in? && current_user.id == @item.collection.user.id
      erb :'items/edit'
    elsif logged_in?
      redirect to "/collections"
    else
      redirect to '/login'
    end
  end
  
  patch '/items/:slug' do
    @item = Item.find_by_slug(params[:slug])
    if !params[:item][:name].empty? && !params[:item][:description].empty?
      @item.update(name: params[:item][:name], description: params[:item][:description])
    else
      redirect to "/items/#{@item.slug}/edit"
    end
  end
  
end