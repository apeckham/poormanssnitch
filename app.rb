require 'sinatra'
require 'moneta'

STORE = Moneta.new(:Memory)

get '/' do
  'poormanssnitch'
end

get '/update/:id' do
  STORE[params[:id]] = {updated_at: Time.now.to_i, ip: request.ip}
  'ok'
end