module Rack::RPC
  ##
  # Represents an RPC service.
  #
  class Service
    ##
    # Defines an operator for this service class.
    #
    # @example
    #   class Calculator < Service
    #     operator Add
    #     operator Subtract
    #     operator Multiply
    #     operator Divide
    #   end
    #
    # @param  [Class] klass
    # @param  [Hash{Symbol => Object}] options
    # @return [void]
    def self.operator(klass, options = {})
      raise TypeError, "expected a Class, but got #{klass.inspect}" unless klass.is_a?(Class)
      @operators ||= {}
      @operators[klass] ||= options
    end
  end # Service
end # Rack::RPC
