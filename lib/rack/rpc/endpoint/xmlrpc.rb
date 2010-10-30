require 'xmlrpc/server' unless defined?(XMLRPC::BasicServer)
begin
  require 'builder/xchar' # @see http://rubygems.org/gems/builder
rescue LoadError => e
end

class Rack::RPC::Endpoint
  ##
  # @see http://en.wikipedia.org/wiki/XML-RPC
  # @see http://www.xmlrpc.com/spec
  module XMLRPC
    CONTENT_TYPE = 'application/xml; charset=UTF-8'

    ##
    # @see http://ruby-doc.org/stdlib/libdoc/xmlrpc/rdoc/classes/XMLRPC/BasicServer.html
    class Server < ::XMLRPC::BasicServer
      ##
      # @param  [Rack::RPC::Server] server
      # @param  [Hash{Symbol => Object}] options
      def initialize(server, options = {})
        super()
        add_multicall     unless options[:multicall]     == false
        add_introspection unless options[:introspection] == false
        add_capabilities  unless options[:capabilities]  == false
        server.class.rpc.each do |rpc_name, method_name|
          add_handler(rpc_name, nil, nil, &server.method(method_name))
        end
      end

      ##
      # @param  [Rack::Request] request
      # @return [Rack::Response]
      def execute(request)
        Rack::Response.new([process(request.body.read)], 200, {
          'Content-Type' => (request.content_type || CONTENT_TYPE).to_s,
        })
      end

      ##
      # Implements the `system.getCapabilities` standard method, enabling
      # clients to determine whether a given capability is supported by this
      # server.
      #
      # @param  [Hash{Symbol => Object}] options
      # @option options [Boolean] :faults_interop (true)
      #   whether to indicate support for the XMLRPC-EPI Specification for
      #   Fault Code Interoperability
      # @return [void]
      # @see    http://xmlrpc-epi.sourceforge.net/specs/rfc.fault_codes.php
      def add_capabilities(options = {})
        add_handler('system.getCapabilities', %w(struct), '') do
          capabilities = {}
          unless options[:faults_interop] == false
            capabilities['faults_interop'] = {
              'specUrl'     => 'http://xmlrpc-epi.sourceforge.net/specs/rfc.fault_codes.php',
              'specVersion' => 20010516,
            }
          end
          capabilities
        end
        self
      end
    end # Server
  end # XMLRPC
end # Rack::RPC::Endpoint
