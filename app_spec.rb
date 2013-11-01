require 'rspec'
require 'rack/test'
require File.dirname(__FILE__) + '/app'

describe Sinatra::Application do
  include Rack::Test::Methods
  
  def app; Sinatra::Application; end
  
  it 'says hello' do
    get '/'
    last_response.body.should == 'poormanssnitch'
  end
end