require File.join(File.dirname(__FILE__), 'spec_helper')
require 'nokogiri'

describe Rack::RPC::Endpoint::XMLRPC do
  it "returns error response when request body is invalid XML RPC" do
    post "/rpc", {},  Factory.valid_xml_request('rack.input' => StringIO.new('misc string'))
    xml = Nokogiri::XML(last_response.body)
    xml.xpath("//methodResponse/fault/value/struct/member").length.should == 2
  end

  it "returns error response when requested method is not defined" do
    post "/rpc", {},  Factory.valid_xml_request('method' => 'fakerpcserver.someunknownmethod')
    xml = Nokogiri::XML(last_response.body)
    xml.xpath("//methodResponse/fault/value/struct/member").length.should == 2
  end

  it "returns a custom error response when using rpc error class" do
    FakeRPCServer.any_instance.stub(:test) do
      raise Rack::RPC::Error.new(123, "error")
    end
    post "/rpc", {},  Factory.valid_xml_request
    xml = Nokogiri::XML(last_response.body)
    path = "//methodResponse/fault/value/struct/member"
    xml.xpath(path).length.should == 2
    xml.xpath("#{path}/value/i4").text.should == "123"
    xml.xpath("#{path}/value/string").text.should == "error"
  end

  it "returns a custom error response with data when using rpc error class with data" do
    FakeRPCServer.any_instance.stub(:test) do
        raise Rack::RPC::Error.new(123, "error", { "request_id" => 6452 })
    end
    post "/rpc", {},  Factory.valid_xml_request
    xml = Nokogiri::XML(last_response.body)
    path = "//methodResponse/fault/value/struct/member"
    xml.xpath(path).length.should == 2
    xml.xpath("#{path}/value/i4").text.should == "123"
    xml.xpath("#{path}/value/string").text.should == "error"
  end

  it "returns valid response when request is valid" do
    post "/rpc", {},  Factory.valid_xml_request
    xml = Nokogiri::XML(last_response.body)
    xml.xpath("//methodResponse/params").length.should == 1
  end
end
