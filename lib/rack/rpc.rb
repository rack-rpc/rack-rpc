require 'rack' # @see http://rubygems.org/gems/rack

module Rack
  module RPC
    autoload :Endpoint,   'rack/rpc/endpoint'
    autoload :Middleware, 'rack/rpc/middleware'
    autoload :Operation,  'rack/rpc/operation'
    autoload :Server,     'rack/rpc/server'
    autoload :VERSION,    'rack/rpc/version'
  end
end
