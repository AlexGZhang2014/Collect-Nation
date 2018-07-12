require 'rack-flash'

class UsersController < ApplicationController
  use Rack::Flash
  
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
    if !User.find_by(username: @user.username) && @user.save
    #if @user.save
      @user.save
      session[:user_id] = @user.id
      redirect to "/collections"
    elsif User.find_by(username: @user.username) && @user.save
      flash[:message] = "That username is already taken. Please select another."
      redirect to "/signup"
    else
      flash[:message] = "Please fill in all fields to continue."
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
      flash[:message] = "You are not logged in yet..."
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