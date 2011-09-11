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
      operands[name.to_sym] = options.merge(:type => type)
    end

    ##
    # Returns the operand definitions for this operation class.
    #
    # @return [Hash{Symbol => Hash}]
    def self.operands
      @operands ||= {}
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
          operands.each do |name, options|
            min += 1 unless options[:optional].eql?(true)
            max += 1
          end
          Range.new(min, max)
        end
      end
    end

    ##
    # Initializes a new operation with the given arguments.
    #
    # @param  [Hash{Symbol => Object}] args
    def initialize(args = [])
      unless self.class.arity.include?(argc = args.count)
        raise ArgumentError, (argc < self.class.arity.min) ?
          "too few arguments (#{argc} for #{self.class.arity.min})" :
          "too many arguments (#{argc} for #{self.class.arity.max})"
      end

      case args
        when Array then initialize_from_array(args)
        when Hash  then initialize_from_hash(args)
        else raise ArgumentError, "expected an Array or Hash, but got #{args.inspect}"
      end

      initialize! if respond_to?(:initialize!)
    end

    ##
    # @private
    def initialize_from_array(args)
      pos = 0
      self.class.operands.each do |param_name, param_options|
        arg = args[pos]; pos += 1

        # TODO: check type/optionality/nullability constraints.

        instance_variable_set("@#{param_name}", arg)
      end
    end
    protected :initialize_from_array

    ##
    # @private
    def initialize_from_hash(args)
      params = self.class.operands
      args.each do |param_name, arg|
        param_options = params[param_name.to_sym]

        unless param_options
          raise ArgumentError, "unknown parameter name #{param_name.inspect}"
        end
        # TODO: check type/optionality/nullability constraints.

        instance_variable_set("@#{param_name}", arg)
      end
    end
    protected :initialize_from_hash

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
