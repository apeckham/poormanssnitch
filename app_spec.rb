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
  
  it 'updates' do
    get '/update/123456'
    last_response.status.should == 200
    last_response.body.should == 'ok'
    STORE['123456'].should == {updated_at: Time.now.to_i, ip: last_request.ip}
  end
end