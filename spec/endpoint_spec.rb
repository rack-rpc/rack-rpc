require File.join(File.dirname(__FILE__), 'spec_helper')

describe Rack::RPC::Endpoint do

  it "handles requests to /rpc by default" do
    post "/rpc", {},  Factory.valid_json_request
    last_response.should be_ok
  end

  it "handles requests to a customized path configured via initialization options" do
    def app
      Rack::RPC::Endpoint.new(sample_app, Factory.sample_server, :path => '/test')
    end
    post "/test", {},  Factory.valid_json_request
    last_response.should be_ok
  end

  it "does not handle GET requests" do
    get "/rpc", {},  Factory.valid_json_request
    last_response.should be_not_found
  end

  it "does not handle PUT requests" do
    put "/rpc", {},  Factory.valid_json_request
    last_response.should be_not_found
  end

  it "does not handle DELETE requests" do
    delete "/rpc", {},  Factory.valid_json_request
    last_response.should be_not_found
  end

  it "handles XML requests (application/xml)" do
    post "/rpc", {},  Factory.valid_xml_request('CONTENT_TYPE'=> 'application/xml')
    last_response.should be_ok
  end

  it "handles XML requests (text/xml)" do
    post "/rpc", {},  Factory.valid_xml_request('CONTENT_TYPE'=> 'text/xml')
    last_response.should be_ok
  end

  it "handles JSON requests (application/json)" do
    post "/rpc", {},  Factory.valid_json_request('CONTENT_TYPE'=> 'application/json')
    last_response.should be_ok
  end

  it "does not handle HTML requests (text/html)" do
    post "/rpc", {},  Factory.valid_json_request('CONTENT_TYPE' => 'text/html')
    last_response.should be_not_found
  end

end
