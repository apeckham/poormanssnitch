require 'sinatra'
require 'moneta'
require 'chronic_duration'
require 'json'

STORE = Moneta.new(:Memory)

get '/' do
  'poormanssnitch'
end

get '/write/:id' do
  STORE[params[:id]] = {updated_at: Time.now.to_i, ip: request.ip}
  status 201
  'ok'
end

get '/read/:id/:duration' do
  record = STORE[params[:id]]
  status 404 and return unless record
  
  duration = ChronicDuration.parse(params[:duration])
  age = Time.now.to_i - record[:updated_at]
  expired = age > duration
  
  status 410 if expired
  record.merge(age: age, expired: expired).to_json
end