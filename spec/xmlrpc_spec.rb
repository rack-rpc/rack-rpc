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

  it "returns valid response when request is valid" do
    post "/rpc", {},  Factory.valid_xml_request
    xml = Nokogiri::XML(last_response.body)
    xml.xpath("//methodResponse/params").length.should == 1
  end
end
