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

def auth_token
  if settings.development?
    authentication_data = YAML.load_file('data/authentication.yml')
    authentication_data['imgur_auth_token']
  else
    ENV['IMGUR_AUTH_TOKEN']
  end
end

def image_links_from_imgur
  data = YAML.load_file('data/data.yml')
  album_id = data['imgur']['album']
  api_url = "https://api.imgur.com/3/album/#{album_id}/images"
  authorization_header = "Bearer #{auth_token}"
  imgur_data = JSON.parse open(api_url, 'Authorization' => authorization_header).string
  links = imgur_data['data'].map { |image| image['link'] }
  links.map { |link| link.gsub('http:', 'https:') }
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