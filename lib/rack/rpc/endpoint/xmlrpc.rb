require 'xmlrpc/server' unless defined?(XMLRPC::BasicServer)
require 'builder'       # @see http://rubygems.org/gems/builder

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
        @server = server
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
        @server.request = request # Store the request so it can be accessed from the server methods
        request_body = request.body.read
        request_body.force_encoding(Encoding::UTF_8) if request_body.respond_to?(:force_encoding) # Ruby 1.9+
        Rack::Response.new([process(request_body)], 200, {
          'Content-Type' => (request.content_type || CONTENT_TYPE).to_s,
        })
      end

      ##
      # Process requests and ensure errors are handled properly
      #
      # @param [String] request body
      def process(request_body)
        begin
          super(request_body)
        rescue RuntimeError => e
          error_response(-32500, "application error - #{e.message}")
        end
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


      ##  
      # Create a valid error response for a given code and message
      #
      # @param [Int] error code
      # @param [String] error message
      # @return [String] response xml string
      def error_response(code, message)
        xml = Builder::XmlMarkup.new
        xml.instruct! :xml, :version=>"1.0"
        xml.methodResponse{ 
          xml.fault {
            xml.value{
              xml.struct{
                xml.member{
                  xml.name('faultCode')
                  xml.value{
                    xml.int(code)
                  }
                }
                xml.member{
                  xml.name('faultString')
                  xml.value{
                    xml.string(message)
                  } 
                }
              } 
            } 
          } 
        }
      end
    end # Server
  end # XMLRPC
end # Rack::RPC::Endpoint
