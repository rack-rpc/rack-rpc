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
    # Defines the `#prepare` instance method.
    #
    # @yield
    # @return [void]
    def self.prepare(&block)
      self.send(:define_method, :prepare) do
        begin
          result = nil
          begin
            before_prepare if respond_to?(:before_prepare)
            result = instance_eval(&block)
          ensure
            after_prepare if respond_to?(:after_prepare)
          end
          result
        rescue Exception => error
          after_error(error) if respond_to?(:after_error)
          raise
        end
      end
    end

    ##
    # Defines the `#execute` instance method.
    #
    # @yield
    # @return [void]
    def self.execute(&block)
      self.send(:define_method, :execute) do
        begin
          before_execute if respond_to?(:before_execute)
          result = instance_eval(&block)
          after_execute if respond_to?(:after_execute)
          result
        rescue Exception => error
          after_error(error) if respond_to?(:after_error)
          raise
        end
      end
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
    # @return [Object]
    attr_reader :context
    def context() @__context__ end

    ##
    # Initializes a new operation with the given arguments.
    #
    # @param  [Hash{Symbol => Object}] args
    def initialize(args = [])
      case args
        when Array then initialize_from_array(args)
        when Hash  then initialize_from_hash(args)
        else case
          when args.respond_to?(:to_args)
            initialize_from_array(args.to_args)
            @__context__ = args.context if args.respond_to?(:context)
          else raise ArgumentError, "expected an Array or Hash, but got #{args.inspect}"
        end
      end

      initialize! if respond_to?(:initialize!)
    end

    ##
    # @private
    def initialize_from_array(args)
      validate_arity!(args)

      pos = 0
      self.class.operands.each do |param_name, param_options|
        arg = args[pos]; pos += 1

        validate_argument!(arg, param_name, param_options)

        instance_variable_set("@#{param_name}", arg)
      end
    end
    protected :initialize_from_array

    ##
    # @private
    def initialize_from_hash(args)
      validate_arity!(args)

      params = self.class.operands
      args.each do |param_name, arg|
        param_options = params[param_name.to_sym]

        raise ArgumentError, "unknown parameter name #{param_name.inspect}" unless param_options
        validate_argument!(arg, param_name, param_options)

        instance_variable_set("@#{param_name}", arg)
      end
    end
    protected :initialize_from_hash

    ##
    # @private
    def validate_arity!(args)
      unless self.class.arity.include?(argc = args.count)
        raise ArgumentError, (argc < self.class.arity.min) ?
          "too few arguments (#{argc} for #{self.class.arity.min})" :
          "too many arguments (#{argc} for #{self.class.arity.max})"
      end
    end
    protected :validate_arity!

    ##
    # @private
    def validate_argument!(arg, param_name, param_options)
      return if arg.nil? && (param_options[:nullable] || param_options[:optional])

      if (param_type = param_options[:type]) && !(param_type === arg)
        case param_type
          when Regexp
            raise TypeError, "expected a String matching #{param_type.inspect}, but got #{arg.inspect}"
          else
            raise TypeError, "expected a #{param_type}, but got #{arg.inspect}"
        end
      end
    end
    protected :validate_argument!

    ##
    # Executes this operation.
    #
    # @abstract
    # @return [void]
    def execute
      raise NotImplementedError, "#{self.class}#execute"
    end

    ##
    # Returns the array representation of the arguments to this operation.
    #
    # @return [Array]
    def to_a
      self.class.operands.inject([]) do |result, (param_name, param_options)|
        result << instance_variable_get("@#{param_name}")
        result
      end
    end

    ##
    # Returns the hash representation of the arguments to this operation.
    #
    # @return [Hash]
    def to_hash
      self.class.operands.inject({}) do |result, (param_name, param_options)|
        result[param_name] = instance_variable_get("@#{param_name}")
        result
      end
    end

    ##
    # Returns the JSON representation of the arguments to this operation.
    #
    # @return [String] a serialized JSON object
    def to_json
      to_hash.to_json
    end
  end # Operation
end # Rack::RPC
