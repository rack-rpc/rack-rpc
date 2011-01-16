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
        # Store the mappings
        @mappings.merge!(mappings)

        # Wrap each method so we can inject before and after callbacks
        mappings.each do |rpc_method_name, server_method|
          self.send(:alias_method, :"#{server_method}_without_callbacks", server_method.to_sym)
          self.send(:define_method, server_method) do |*args|
            self.class.hooks[:before].each{|command| command.call(self) if command.callable?(server_method)}
            out = self.send(:"#{server_method}_without_callbacks", *args)
            self.class.hooks[:after].each{|command| command.call(self) if command.callable?(server_method)}
            out
          end
        end
      end
    end

    def self.hooks
      @hooks ||= {:before => [], :after => []}
    end

    def self.before_filter(method_sym = nil, options = {}, &block)
      setup_hook(:before, method_sym, options, block)
    end

    def self.after_filter(method_sym = nil, options = {}, &block)
      setup_hook(:after, method_sym, options, block)
    end

    # @return [Hash]
    attr_reader :options

    # @return Rack::Request
    attr_accessor :request

    ##
    # @param  [Hash] options
    def initialize(options = {}, &block)
      @options = options.dup
      block.call(self) if block_given?
    end

    private

    def self.setup_hook(type, method, options, proc)
      hooks[type] << if proc
        ProcCommand.new(proc, options)
      else
        MethodCommand.new(method, options)
      end
    end

  end # Server

  class Command
    attr_reader :options

    def initialize(options)
      @options = options

      # Convert non-array options to arrays
      [:only, :except].each do |option|
        options[option] = [options[option]] if !options[option].nil? && !options[option].is_a?(Array)
      end
    end

    def callable?(method)
      options.empty? ||
      (!options[:only].nil? && options[:only].include?(method)) ||
      (!options[:except].nil? && !options[:except].include?(method))
    end
  end

  class ProcCommand < Command
    def initialize(proc, options)
      @proc = proc.to_proc
      super(options)
    end

    def call(server)
      server.instance_eval(&@proc)
    end
  end # ProcCommand

  class MethodCommand < Command
    def initialize(method, options)
      @method = method.to_sym
      super(options)
    end

    def call(server)
      server.__send__(@method)
    end
  end # MethodCommand
end; end # Rack::RPC
