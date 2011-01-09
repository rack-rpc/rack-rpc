require 'rack/rpc'
require 'rack/test'
Dir[File.dirname(__FILE__) + "/fixtures/*.rb"].each {|f| require f}

def sample_app
  mock("Example Rack App", :call =>[404, {}, ["Not Found"]])
end


RSpec.configure do |config|
  config.mock_with :rspec
  config.include Rack::Test::Methods

  def app
    Rack::RPC::Endpoint.new(sample_app, FakeRPCServer.new)
  end
end
