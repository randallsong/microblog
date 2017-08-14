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
	erb :loginfailed
end

get '/edit' do
	erb :edit
end

get '/profile' do
	@user = User.find(session[:user_id])
<<<<<<< HEAD
	@profile = @user.profile
	@posts = Post.all
=======
	@posts = @user.posts
	@profiles = Profile.find(session[:user_id])
>>>>>>> 94335b9f6b35bad824282a62603299ee0515d3cc
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
		session[:user_id] = @user.id
		current_user
		erb :community
	end
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

post '/new-post' do
	@user = session[:user_id]
	@post = Post.create(:comment => params[:comment_text])
	redirect '/profile'
end

# editing a post
get '/posts/:id/editpost' do
	@user = session[:user_id]
	@post = Post.find_by_id(params[:id])
	erb :editpost
end

patch '/posts/:id' do
	@user = session[:user_id]
	@post = Post.find_by_id(params[:id])
	@post.content = params[:content]
	@post.save
	redirect to "/profile"
end

# # deleting a post
# delete '/posts/:id/delete' do
# 	@post = Post.find_by_id(params[:id])
# 	@post.delete
# 	redirect to '/posts'
# end

def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	else
		redirect '/signin'
	end
end

def log_out
	if current_user
		session[:user_id] = nil
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