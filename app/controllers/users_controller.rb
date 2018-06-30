class UsersController < ApplicationController
  get '/' do
    erb :index
  end
  
  get '/signup' do
    if logged_in?
      redirect to '/collections'
    else
      erb :'users/signup'
    end
  end
  
  post '/signup' do
    @user = User.new(username: params[:username], email: params[:email], password: params[:password])
    if @user.save
      @user.save
      session[:user_id] = @user.id
      redirect to "/collections"
    else
      redirect to "/signup"
    end
  end
  
  get '/login' do
    erb :'users/login'
  end
end