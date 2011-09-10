module Rack::RPC
  ##
  # Represents an RPC server operation.
  #
  class Operation
    ##
    # Defines an operand for this operation class.
    #
    # @example
    #   class Multiply < Operation
    #     operand :x, Numeric
    #     operand :y, Numeric
    #   end
    #
    # @param  [Symbol, #to_sym] name
    # @param  [Class] type
    # @param  [Hash{Symbol => Object}] options
    # @option options [Boolean] :optional (false)
    # @option options [Boolean] :nullable (false)
    # @return [void]
    def self.operand(name, type = Object, options = {})
      raise TypeError, "expected a Class, but got #{type.inspect}" unless type.is_a?(Class)
      @operands ||= {}
      @operands[name.to_sym] = options.merge(:type => type)
    end

    ##
    # Returns the arity range for this operation class.
    #
    # @return [Range]
    def self.arity
      @arity ||= begin
        if const_defined?(:ARITY)
          const_get(:ARITY)
        else
          min, max = 0, 0
          @operands ||= {}
          @operands.each do |name, options|
            min += 1 unless options[:optional].eql?(true)
            max += 1
          end
          Range.new(min, max)
        end
      end
    end

    ##
    # Executes this operation.
    #
    # @abstract
    # @return [void]
    def execute
      raise NotImplementedError, "#{self.class}#execute"
    end
  end # Operation
end # Rack::RPC
