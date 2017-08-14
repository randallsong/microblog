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

get '/login' do
	@users = User.all
	@profiles = Profile.all
	@posts = Post.all
	erb :login
end

post '/login' do
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

get '/community' do
	@user = User.find(session[:user_id])
	@posts = Post.all
	@profiles = Profile.find(session[:user_id])
	erb :community
end	


get '/loginfailed' do
	@user = User.find(session[:user_id])
	@posts = Post.all
	@profiles = Profile.all
	erb :loginfailed
end

get '/edit' do
	erb :edit
end

get '/profile' do
	@user = User.find(session[:user_id])
	@posts = Post.all
	@profiles = Profile.find(session[:user_id])
	erb :profile
end

get '/signup' do
	@user = User.find(session[:user_id])
	@posts = Post.all
	@profiles = Profile.all
	erb :signup
end

post '/signup' do
	if (params[:fname] != "" && params[:pwd] != "") && ( User.where(fname: params[:fname]).exists? )
		redirect '/signup'
	else 
		User.create(fname: params[:fname], pwd: params[:pwd])
		@user = User.where(fname: params[:fname]).first
		session[:user_id] = @user.id
		current_user
		erb :community
	end
end

get '/loginfailed' do
	erb :loginfailed
end

get 'signup' do
	erb :signup
end


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
	else
		redirect '/signin'
	end
end


def display_users
	User.all
end

def destroy_user 
	current_user

	if current_user
		@current_user_id = @user.id
		@currentUser.destroy
		session[:user_id] = nil
	else
	end
end