require 'sinatra'
require 'moneta'
require 'chronic_duration'
require 'json'

STORE = Moneta.new(:Memory)

get '/' do
  'poormanssnitch'
end

get '/write/:id' do
  STORE[params[:id]] = Time.now.to_i
  status 201
  'updated'
end

get '/read/:id/:max_age' do
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