require 'spec_helper'

describe ApplicationController do

  describe "Homepage" do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome to Collect Nation!")
    end
  end
  
  describe "Signup Page" do
    it 'loads the signup page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end
    
    it 'logs in the user to the collections index page after signing up' do
      params = {
        :username => "The Joker",
        :email => "jokerking50@gmail.com"
        :password => "jokerrules"
      }
      post '/signup', params
      expect(last_response.location).to include("/collections")
    end
    
    it 'does not let a user sign up without a username' do
      params = {
        :username => "",
        :email => "jokerking50@gmail.com"
        :password => "jokerrules"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end
  end
  
end