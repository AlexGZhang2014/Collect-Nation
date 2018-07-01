require 'rack-flash'

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
      if !User.find_by_slug(@user.slug)
        @user.save
        session[:user_id] = @user.id
        redirect to "/collections"
      else
        flash[:message] = "That username is already taken. Please choose a different username."
        redirect to '/signup'
      end
    else
      flash[:message] = "Please fill in all fields."
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
      flash[:message] = "Incorrect username and/or password. Please try again."
      redirect to "/login"
    end
  end
  
  get '/logout' do
    if logged_in?
      session.clear
      redirect to "/login"
    else
      redirect to '/'
    end
  end
  
  get '/users' do
    if logged_in?
      @users = User.all
      erb :'users/index'
    else
      redirect to '/login'
    end
  end
  
  get '/users/:slug' do
    if logged_in?
      @user = User.find_by_slug(params[:slug])
      erb :'users/show'
    else
      flash[:message] = "Sorry, but you cannot view this user without being logged in."
      redirect to '/login'
    end
  end
end