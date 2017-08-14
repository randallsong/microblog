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
    session.clear
end
post 'login' do
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
get '/loginfailed' do
    @user = User.find(session[:user_id])
    @posts = Post.all
    @profiles = Profile.all
    erb :loginfailed
end
get '/community' do
    @user = User.find(session[:user_id])
    @posts = Post.all
    @profiles = Profile.find(session[:user_id])
    erb :community
end 
get '/profile' do
    @user = User.find(session[:user_id])
    @posts = Post.all
    @profiles = Profile.all
    erb :profile
end
get '/edit' do
    @user = User.find(session[:user_id])
    @posts = Post.all
    @profiles = Profile.all
    erb :edit
end
post 'edit' do
    
get '/newpost' do
    @user = User.find(session[:user_id])
    @posts = Post.all
    @profiles = Profile.all
    erb :newpost
end
get '/signup' do
    erb :signup
end
post '/signup' do
    if params[:fname] != "" && params[:pwd] != ""
        User.create(fname params[:fname], pwd params[:pwd])
    else 
    redirect 'signup'
end
    @user = User.where(fname: params[:fname]).first
    session[:user_id] = @user.id
    current_user
    erb :community
def current_user
    if session[:user_id]
        @current_user = User.find(session[:user_id])
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
    end
end