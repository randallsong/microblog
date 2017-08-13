require 'sinatra'
require 'sinatra/activerecord'
require 'bundler/setup'
require 'sinatra/flash'

set :database, "sqlite3:myPony.sqlite3"

enable :sessions

require './models'

get '/' do
	@users = User.all
	@profiles = Profile.all
	@posts = Post.all
	erb :login
end

get '/community' do
	@user = User.find(session[:user_id])
	@posts = Post.all
	@profiles = Profile.all
	erb :community
end

get '/profile' do
	@user = User.find(session[:user_id])
	@posts = Post.all
	@profiles = Profile.all
	erb :profile
end

get '/editprofile' do
	@user = User.find(session[:user_id])
	@posts = Post.all
	@profiles = Profile.all
	erb :editprofile
end

get '/loginfailed' do
	@user = User.find(session[:user_id])
	@posts = Post.all
	@profiles = Profile.all
	erb :loginfailed
end

get '/newpost' do
	@user = User.find(session[:user_id])
	@posts = Post.all
	@profiles = Profile.all
	erb :newpost
end

post '/profile' do
	@user = User.find(session[:user_id])
	@comment = Post.create(params[:comment_text])
end

get '/signup' do
	erb :signup
end

# post '/signup' do
# 	@newuser

# 	@user = User.create(fname: params[:fname])


post '/community' do 
	@user = User.where(fname: params[:fname]).first
	if @user && @user.pwd == params[:pwd]
		session[:user_id] = @user.id
		flash[:notice] = "You've been signed in successfully."
	else
		flash[:alert] = "Authorization failed"
		redirect '/loginfailed'
	end
	redirect '/community'
end

def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	end
end

def display_users
	User.all
end
