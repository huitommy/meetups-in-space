require 'sinatra'
require_relative 'config/application'
require 'time'

helpers do
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      session[:user_id] = nil unless @current_user
    end
    @current_user
  end
end

get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  session[:user_id] = user.id
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = 'You have been signed out.'

  redirect '/'
end

get '/meetups' do
  @meetups = Meetup.all.order(name: :asc)
  erb :'meetups/index'
end

get '/meetups/new' do
  erb :'meetups/new'
end

get '/meetups/:id' do
  current_user
  @show_button = nil
  id = params[:id]
  @meetup = Meetup.find_by(id: id)
  attendants = @meetup.users.ids

  if current_user.nil?
    @show_button = true
  elsif !attendants.include?(@current_user.id)
    @show_button = true
  end

  erb :'meetups/show'
end

post '/meetups' do
  current_user
  @error = nil
  @name = params[:name]
  @location = params[:location]
  @description = params[:description]

  if @current_user.nil?
    @error = 'Please sign in before posting any meetups'
    erb :'meetups/new'
  elsif @name.empty? || @location.empty? || @description.empty?
    @error = 'Please fill in all form fields'
    erb :'meetups/new'
  else
    meetup = Meetup.create(name: @name, location: @location, description: @description, user_id: @current_user.id)
    MeetupUser.create(user_id: @current_user.id, meetup_id: meetup.id, meetup_creator_id: @current_user.id)
    flash[:notice] = 'You have successfully posted a meetup'
    redirect "/meetups/#{meetup.id}"
  end
end

post '/meetups/:id/join' do
  current_user
  id = params[:id]

  if @current_user.nil?
    flash[:notice] = 'Please sign in before joining meetups'
  else
    @meetup = Meetup.find_by(id: id)
    MeetupUser.create(user_id: @current_user.id, meetup_id: id, meetup_creator_id: @meetup.user_id)
    flash[:notice] = 'You have joined the meetup.'
  end

  redirect "/meetups/#{id}"
end
