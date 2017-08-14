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
	@profiles = Profile.find(session[:user_id])
	erb :community
end

get '/edit' do
	erb :edit
end

get '/profile' do
	@user = User.find(session[:user_id])
	@profiles = Profile.find(session[:user_id])
	@posts = Post.find(session[:user_id])
	erb :profile
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
	end
end


def display_users
	User.all
end