class ItemsController < ApplicationController
  get '/items/:slug' do
    if logged_in?
      @item = Item.find_by_slug(params[:slug])
      erb :'items/show'
    else
      redirect to '/login'
    end
  end
end