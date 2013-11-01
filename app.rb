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
  'ok'
end

get '/read/:id/:duration' do
  record = STORE[params[:id]]
  duration = ChronicDuration.parse(params[:duration])
  expired = Time.now.to_i - record[:updated_at] > duration
  
  status 500 if expired
  record.merge(status: expired ? 'expired' : 'current').to_json
end