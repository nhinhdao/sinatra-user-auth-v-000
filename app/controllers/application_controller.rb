class ApplicationController < Sinatra::Base
   register Sinatra::ActiveRecordExtension
   set :views, Proc.new { File.join(root, "../views/") }

   configure do
      enable :sessions
      set :session_secret, "secret"
   end

   get '/' do
      erb :home
   end

   get '/registrations/signup' do
      erb :'/registrations/signup'
   end

   post '/registrations' do
      # binding.pry
      @user = User.new(name: params["name"], email: params["email"], password: params["password"])
      @user.save
      session[:id] = @user.id
      redirect '/users/home'
   end

   get '/sessions/login' do
      erb :'sessions/login'
   end

   post '/sessions' do
      if @user = User.find_by(email: params["email"], password: params["password"])
      session[:id] = @user.id
      redirect '/users/home'
      else
         'You enter wrong password. Please try again.'
         redirect '/sessions/login'
      end
   end

   get '/sessions/logout' do
      session.clear
      redirect '/'
   end

   get '/users/home' do
      @user = User.find(session[:id])
      erb :'/users/home'
   end

end
