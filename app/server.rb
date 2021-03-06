require 'sinatra'
require 'data_mapper'
require 'rack-flash'

env = ENV["RACK_ENV"] || "development"
# we're telling datamapper to use a postgres database on localhost.
#The name will be "bookmark_manager_test" or "bookmark_manager_developemnt" depending on the environment

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

require './lib/link' #this needs to be done after DataMapper is initalised
require './lib/tag'
require './lib/user'
require './app/helpers/application'
#After declaring your models, you should finalise them
DataMapper.finalize

#However, our database tables don't exist yet. Let's tell datamapper to create them
DataMapper.auto_upgrade!
# auto_upgrade makes non-destructive changes. It your tables don't exist, they will be created
# but if they do and you changed your schema (e.g. changed the type of one of the properties)
# they will not be upgraded because that'd lead to data loss.
# To force the creation of all tables as they are described in your models, even if this
# leads to data loss, use auto_migrate:
# DataMapper.auto_migrate!
# Finally, don't forget that before you do any of that stuff, you need to create a database first.
use Rack::Flash
use Rack::MethodOverride
enable :sessions
set :session_secret, 'super sweet secret'


get '/' do 
  @links = Link.all
  erb :index
end

get '/tags/:text' do
  tag = Tag.first(:text => params[:text])
  @links = tag ? tag.links : []
  erb :index
end

get '/users/new' do
  @user = User.new
  erb :"users/new"
end

post '/links' do
  url = params["url"]
  title = params["title"]
  tags = params["tags"].split(" ").map do |tag|
    Tag.first_or_create(:text => tag)
  end
  Link.create(:url => url, :title => title, :tags => tags)
  redirect to('/')
end

post '/users' do
  @user = User.new(:email => params[:email],
                     :password => params[:password],
                     :password_confirmation => params[:password_confirmation])
  if @user.save
    session[:user_id] = @user.id
    redirect to('/')
  else
    flash.now[:errors] = @user.errors.full_messages
    erb :"users/new"
  end
end

get '/sessions/new' do
  erb :"sessions/new"
end

post '/sessions' do
  email, password = params[:email], params[:password]
  user = User.authenticate(email, password)
  if user
    session[:user_id] = user.id
    redirect to('/')
  else
    flash[:errors] = ["The email or password are incorrect"]
    erb :"sessions/new"
  end
end

delete '/sessions' do
  flash[:notice] = "Good bye!"
  session[:user_id] = nil
  erb :"sessions/new"
end









