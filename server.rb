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

set :public_folder, settings.root + '/client/dist'

get '/' do
  send_file './client/dist/index.html'
end

post '/movie' do
  content_type :json
  db = settings.mongo_db
  data =  JSON.parse(request.body.read)["data"]
  result = db.insert_one data
  db.find(:_id => result.inserted_id).to_a.first.to_json
end

get '/search' do
  response['Access-Control-Allow-Origin'] = 'http://localhost:8080'
  query = params[:q]
  result = HTTParty.get("http://www.omdbapi.com/?apikey=#{OMDB_KEY}&t=#{query}").to_h
  record = settings.mongo_db.find(id: result["imdbID"]).to_a.first
  if record
    result["rating"] = record[:rating]
    result["comment"] = record[:comment]
  end
  json result.to_json
end