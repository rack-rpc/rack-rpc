module Rack; module RPC
  ##
  # A Rack middleware base class.
  class Middleware
    # @return [#call]
    attr_reader :app

    # @return [Hash]
    attr_reader :options

    ##
    # @param  [#call] app
    # @param  [Hash] options
    def initialize(app, options = {})
      @app, @options = app, options.dup
    end

    ##
    # @param  [Hash] env
    # @return [Array]
    def call(env)
      @app.call(env)
    end
  end # Middleware
end; end # Rack::RPC
