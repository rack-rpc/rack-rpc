require File.join(File.dirname(__FILE__), 'spec_helper')

describe Rack::RPC::Server do
  it "maps rpc method names to instance methods" do
    Rack::RPC::FakeRPCServer.rpc['fakerpcserver.test'].should == :test
    Rack::RPC::FakeRPCServer.rpc['fakerpcserver.some_unknown_method'].should == nil
  end
end
