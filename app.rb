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
	@profiles = Profile.find_by_user_id(@user.id)
	erb :community
end	

get '/loginfailed' do
	@user = User.find(session[:user_id])
	@posts = Post.all
	@profiles = Profile.all
	erb :loginfailed
end

get '/edit' do
	@user = User.find(session[:user_id])
	erb :edit
end

post '/edit' do
  @user = User.find(session[:user_id])
  @user.fname = params[:newname]
  @user.save
  redirect to "/profile"
end

get '/profile' do
	@user = User.find(session[:user_id])
	@posts = @user.posts
	@profiles = Profile.find_by_user_id(@user.id)
	erb :profile
end

get '/signup' do
	erb :signup
end

post '/signup' do
	if (params[:fname] != "" && params[:pwd] != "") && ( User.where(fname: params[:fname]).exists? )
		redirect '/signup'
	else 
		User.create(fname: params[:fname], pwd: params[:pwd])
		@user = User.where(fname: params[:fname]).first
		Profile.create(:user_id => @user.id , :avatar => "Images/pic1.png")
		session[:user_id] = @user.id
		current_user
	end
	redirect "/community"
end

get '/logoutpage' do
	@user = User.find(session[:user_id])
	session.clear
	erb :logoutpage
end

post '/logoutpage' do
	redirect '/community'
end

get '/loginfailed' do
	erb :loginfailed
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

get '/newpost' do
	@user = User.find(session[:user_id])
	@profiles = Profile.find_by_user_id(@user.id)
	erb :newpost
end

post '/newpost' do
	@user = session[:user_id]
	@post = Post.create(:user_id => @user, :comment => params[:comment_text])
	redirect '/profile'
end

get '/delete' do
	erb :delete
end

post '/delete' do
	@user = User.find(session[:user_id])
	@post = @user.posts
	@profiles = Profile.find_by_user_id(@user.id)
	@user.destroy
	@post.destroy
	@profiles.destroy
	redirect '/login'
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

	redirect 'signin'
end

