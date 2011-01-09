require File.join(File.dirname(__FILE__), 'spec_helper')

describe Rack::RPC::Endpoint::JSONRPC do
  it "returns error response when request body is invalid JSON RPC 2.0" do
    post "/rpc", {},  Factory.valid_json_request('rack.input' => StringIO.new('misc string'))
    response = JSON.parse(last_response.body)
    response['error'].should_not be_nil
  end

  it "returns error response when requested method is not defined" do
    post "/rpc", {},  Factory.valid_json_request('method' => 'fakerpcserver.someunknownmethod')
    response = JSON.parse(last_response.body)
    response['error'].should_not be_nil
  end

  it "returns valid response when request is valid" do
    post "/rpc", {},  Factory.valid_json_request
    response = JSON.parse(last_response.body)
    response['result'].should == FakeRPCServer.new.test
    response['id'].should == Factory.valid_json_request_hash['id']
  end
end
