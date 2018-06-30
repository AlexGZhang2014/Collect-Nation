class UsersController < ApplicationController
  get '/' do
    erb :index
  end
  
  get '/signup' do
    erb :'users/signup'
  end
  
  get '/login' do
    erb :'users/login'
  end
end