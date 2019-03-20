require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/json'
require 'httparty'

OMDB_KEY = ENV['OMDB_KEY']

set :public_folder, settings.root + '/client/dist'

get '/' do
  send_file './client/dist/index.html'
end

get '/search' do
  response['Access-Control-Allow-Origin'] = 'http://localhost:8080'
  query = params[:q]
  json HTTParty.get("http://www.omdbapi.com/?apikey=#{OMDB_KEY}&t=#{query}")
end