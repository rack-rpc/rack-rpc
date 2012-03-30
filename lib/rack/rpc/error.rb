require "xmlrpc/parser" unless defined?(XMLRPC::FaultException)

module Rack::RPC
  ##
  # Represents an RPC Exception service.
  #
  class Error < XMLRPC::FaultException
    attr_reader :data

    alias code faultCode
    alias message faultString
    alias to_s faultString

    ##
    # Creates a new rpc related exception. This is useful if one wants to define
    # custom exceptions.
    # @param  [Fixnum] code an error code for the exception (used for mapping
    #   on the client side)
    # @param  [String] message the message that should be send along
    # @param  [Object] a data object that may contain additional data on the
    #   error (CAUTION: this is not possible with XMLRPC)
    def initialize(code, message, data = nil)
      @data = data
      super(code, message)
    end
  end
end
