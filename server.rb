require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/json'
require 'httparty'
require 'mongo'
require 'json/ext' # required for .to_json
require 'pry' if development?

MONGODB_URI = ENV['MONGODB_URI']
OMDB_KEY = ENV['OMDB_KEY']

configure do
  db = Mongo::Client.new([ MONGODB_URI ], :database => 'omdb')
  set :mongo_db, db[:omdb]
end

db = settings.mongo_db

set :public_folder, settings.root + '/client/dist'

get '/' do
  send_file './client/dist/index.html'
end

get '/movies' do
  json db.find.to_a.to_json
end

post '/movie' do
  data =  JSON.parse(request.body.read)["data"]
  result = db.insert_one data
  json db.find(:_id => result.inserted_id).to_a.first.to_json
end

get '/search' do
  query = params[:q]
  result = HTTParty.get("http://www.omdbapi.com/?apikey=#{OMDB_KEY}&t=#{query}").to_h
  record = settings.mongo_db.find(imdbID: result["imdbID"]).to_a.first
  if record
    json record.to_json
  else
    json result.to_json
  end
end