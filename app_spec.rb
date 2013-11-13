require 'rspec'
require 'rack/test'
require 'timecop'
require File.dirname(__FILE__) + '/app'

describe Sinatra::Application do
  include Rack::Test::Methods
  
  def app; Sinatra::Application; end
  
  before { Timecop.freeze }
  
  it 'says hello' do
    get '/'
    last_response.body.should == 'poormanssnitch'
  end
  
  it 'writes' do
    get '/write/123456'
    last_response.status.should == 201
    last_response.body.should == 'updated'
    STORE['123456'].should == Time.now.to_i
  end
  
  it 'reads' do
    get '/write/123456'
    last_response.status.should == 201
    last_response.body.should == 'updated'

    get '/read/123456/2m'
    last_response.status.should == 200
    last_response.body.should == 'current, age=0'
    
    Timecop.travel 130
    get '/read/123456/2m'
    last_response.status.should == 410
    last_response.body.should == 'expired, age=130'

    get '/read/123456/5m'
    last_response.status.should == 200
    last_response.body.should == 'current, age=130'
  end
  
  it 'returns a 404 when record is missing' do
    get '/read/101010/2m'
    last_response.status.should == 404
  end
  
  it 'returns a 500 when time is bad' do
    get '/write/123456789'
    get '/read/123456789/whatever'
    last_response.status.should == 500
  end
  
  it 'returns a 500 when time is 0s' do
    get '/write/1234567890'
    get '/read/1234567890/0s'
    last_response.status.should == 500
  end
  
  it 'allows posts' do
    post '/write/asdfasdf'
    last_response.status.should == 201

    post '/read/asdfasdf/5s'
    last_response.status.should == 200
  end
end