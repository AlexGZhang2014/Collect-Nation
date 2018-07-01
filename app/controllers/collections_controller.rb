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
  
  post '/collections' do
    if !params[:collection][:name].empty? && !params[:collection][:description].empty?
      @collection = Collection.new(params[:collection])
      @collection.user = current_user
      if !params[:item][:name].empty? && !params[:item][:description].empty?
        @collection.items << Item.create(params[:item])
      end
      @collection.save
      redirect to "/collections/#{@collection.slug}"
    else
      redirect to "/collections/new"
    end
  end
end