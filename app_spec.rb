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
    last_response.body.should == 'ok'
    STORE['123456'].should == {updated_at: Time.now.to_i, ip: last_request.ip}
  end
  
  it 'reads' do
    now = Time.now
    get '/write/123456'
    last_response.status.should == 201
    last_response.body.should == 'ok'

    get '/read/123456/2m'
    last_response.status.should == 200
    JSON.parse(last_response.body).should == {'updated_at' => now.to_i, 'ip' => last_request.ip, 'expired' => false, 'age' => 0}
    
    Timecop.travel 130
    get '/read/123456/2m'
    last_response.status.should == 410
    JSON.parse(last_response.body).should == {'updated_at' => now.to_i, 'ip' => last_request.ip, 'expired' => true, 'age' => 130}

    get '/read/123456/5m'
    last_response.status.should == 200
    JSON.parse(last_response.body).should == {'updated_at' => now.to_i, 'ip' => last_request.ip, 'expired' => false, 'age' => 130}
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
end