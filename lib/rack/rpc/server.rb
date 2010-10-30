module Rack; module RPC
  ##
  # A base class for RPC servers.
  class Server
    ##
    # @private
    def self.rpc(mappings = {})
      @mappings ||= {}
      if mappings.empty?
        @mappings
      else
        @mappings.merge!(mappings)
      end
    end

    # @return [Hash]
    attr_reader :options

    ##
    # @param  [Hash] options
    def initialize(options = {}, &block)
      @options = options.dup
      block.call(self) if block_given?
    end
  end # Server
end; end # Rack::RPC
