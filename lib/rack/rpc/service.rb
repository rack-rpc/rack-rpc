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
      operators[klass] ||= options
    end

    ##
    # Returns the operator definitions for this service class.
    #
    # @return [Hash{Class => Hash}]
    def self.operators
      @operators ||= {}
    end

    ##
    # Returns the operator class for the given operator name.
    #
    # @param  [Symbol, #to_sym] operator_name
    # @return [Class]
    def self.[](operator_name)
      operator_name = operator_name.to_sym
      operators.find do |klass, options|
        klass_name = klass.name.split('::').last # TODO: optimize this
        return klass if operator_name.eql?(klass_name.to_sym)
      end
    end
  end # Service
end # Rack::RPC
