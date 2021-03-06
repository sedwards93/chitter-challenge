require './lib/user'
require './lib/databaseconnection'
require_relative 'app'
require 'uri'
require 'sinatra/flash'



class UserController < Sinatra::Base 

  configure do
    enable :sessions, :method_override
    register Sinatra::Flash

    set :views, './views'
  end

  get '/users/new' do
    erb :"new_user"
  end

  post '/users' do
    @user = User.create(name: params['name'], username: params['username'], email: params['email'], password: params['password'])
    if @user != false
      session[:user_id] = @user.id
      session[:username] = @user.username
      redirect "users/#{@user.id}"
    else flash[:notice] = "Please give us a real email FFS!"
      redirect '/users/new'
    end
  end

  get '/users/:id' do
    @user = User.find(session[:user_id])
    erb :"show"
  end

end