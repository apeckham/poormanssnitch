require 'sinatra'
require 'moneta'
require 'chronic_duration'
require 'json'

STORE = if ENV['REDIS_URL']
  uri = URI.parse ENV['REDIS_URL']
  Moneta.new(:Redis, host: uri.host, port: uri.port, password: uri.password)
else
  Moneta.new(:Memory)
end

def self.get_or_post(url, &block)
  get(url, &block)
  post(url, &block)
end

get '/' do
  'poormanssnitch'
end

get_or_post '/write/:id' do
  STORE[params[:id]] = Time.now.to_i
  status 201
  'updated'
end

get_or_post '/read/:id/:max_age' do
  updated_at = STORE[params[:id]]
  status 404 and return unless updated_at
  
  max_age = ChronicDuration.parse params[:max_age]
  age = Time.now.to_i - updated_at
  
  if age > max_age
    status 410
    "expired, age=#{age}"
  else
    "current, age=#{age}"
  end
end