module Rack; module RPC
  ##
  # A Rack middleware for RPC endpoints.
  class Endpoint < Middleware
    autoload :JSONRPC, 'rack/rpc/endpoint/jsonrpc'
    autoload :XMLRPC,  'rack/rpc/endpoint/xmlrpc'

    DEFAULT_PATH = '/rpc'

    # @return [Server]
    attr_reader :server
    def server
      @server = @server.call if @server.is_a?(Proc)
      @server
    end

    ##
    # @param  [#call] app
    # @param  [Server] server
    # @param  [Hash] options
    def initialize(app, server, options = {})
      @server = server
      super(app, options)
    end

    ##
    # @return [String]
    def path
      @path ||= options[:path] || DEFAULT_PATH
    end

    ##
    # @param  [Hash] env
    # @return [Array]
    def call(env)
      return super unless env['PATH_INFO'].eql?(path)
      return super unless env['REQUEST_METHOD'].eql?('POST')
      case content_type = env['CONTENT_TYPE']
        when %r(^application/xml), %r(^text/xml)
          XMLRPC::Server.new(server).execute(Rack::Request.new(env)).finish
        when %r(^application/json)
          JSONRPC::Server.new(server).execute(Rack::Request.new(env)).finish
        else super
      end
    end
  end # Endpoint
end; end # Rack::RPC
