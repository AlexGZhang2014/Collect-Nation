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
    if logged_in?
      redirect to '/collections'
    else
      erb :'users/login'
    end
  end
  
  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to "/collections"
    else
      redirect to "/login"
    end
  end
  
  get '/logout' do 
    session.clear
    redirect to "/login"
  end
end