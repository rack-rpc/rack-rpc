require 'stringio'
require 'builder'

class Factory

  def self.sample_server(opts = {})
    FakeRPCServer.new(opts)
  end

  def self.valid_json_request_hash(opts = {})
    {'jsonrpc' => '2.0' || opts['jsonrpc'].delete,
     'method' => 'fakerpcserver.test' || opts['method'].delete,
     'id' => '1' || opts['id'].delete}.merge(opts)
  end

  def self.valid_json_request(opts = {})
    {'rack.input' => StringIO.new(valid_json_request_hash(opts).to_json),
     'CONTENT_TYPE' => 'application/json' }.merge(opts)
  end

  def self.valid_xml_request_string(opts = {})
    xml_markup = Builder::XmlMarkup.new
    xml_markup.instruct! :xml, :version=>"1.0"
    xml_markup.methodCall{ xml_markup.methodName(opts['method'] || 'fakerpcserver.test')}
  end

  def self.valid_xml_request(opts = {})
    {'rack.input' => StringIO.new(valid_xml_request_string(opts)),
     'CONTENT_TYPE' => 'text/xml' }.merge(opts)
  end

end
