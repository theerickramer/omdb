require 'sinatra'
require "sinatra/reloader" if development?

OMDB_KEY = ENV['OMDB_KEY']

set :public_folder, settings.root + '/client/dist'

get '/' do
  send_file './client/dist/index.html'
end