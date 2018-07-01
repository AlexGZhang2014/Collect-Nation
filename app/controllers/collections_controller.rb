class CollectionsController < ApplicationController
  get '/collections' do
    if logged_in?
      @collections = Collection.all
      erb :'collections/index'
    else
      redirect to '/login'
    end
  end
  
  get '/collections/new' do
    if logged_in? && 
      erb :'collections/new'
    else
      redirect to '/login'
    end
  end
end