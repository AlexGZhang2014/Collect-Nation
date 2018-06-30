class CollectionsController < ApplicationController
  get '/collections' do
    if logged_in?
      @collections = Collection.all
      erb :'collections/index'
    else
      redirect to '/login'
    end
  end
end