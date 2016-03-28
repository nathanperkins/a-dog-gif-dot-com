require 'sinatra'
require 'tilt/erubis'
require 'yaml'
require 'rack'
require 'rack/ssl'
require 'open-uri'
require 'json'

use Rack::SSL

if development?
  require 'sinatra/reloader'
  require 'pry'
end

configure do
  set :erb, :escape_html => true
end

def image_links_from_imgur
  secret_data = YAML.load_file('data/secret_authentication.yml')
  album_id = secret_data['imgur']['album']
  api_url = "https://api.imgur.com/3/album/#{album_id}/images"
  authorization_header = 'Bearer 482ffa280b7cc4d1c06646965e082ec82fc30407'
  imgur_data = JSON.parse open(api_url, 'Authorization' => authorization_header).string
  imgur_data['data'].map { |image| image['link'] }
end

before do
  @image_links = image_links_from_imgur
end

get '/' do
  @dog_link = @image_links.sample
  erb :index
end

get '/gif' do
  @dog_link = @image_links.sample
end

get '/*' do
  redirect '/'
end