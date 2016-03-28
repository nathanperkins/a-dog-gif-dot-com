require 'sinatra'
require 'tilt/erubis'
require 'yaml'
require 'rack'
require 'rack/ssl'

use Rack::SSL

if development?
  require 'sinatra/reloader'
  require 'pry'
end

configure do
  set :erb, :escape_html => true
end

before do
  @data = YAML.load_file('public/dogs.yml')
end

get '/' do
  @dog_link = @data['dogs'].sample
  erb :index
end

get '/gif' do
  @dog_link = @data['dogs'].sample
end

get '/*' do
  redirect '/'
end