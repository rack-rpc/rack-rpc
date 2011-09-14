#!/usr/bin/env rackup
$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib')))
require 'rack/rpc'

module Calc
  class Add < Rack::RPC::Operation
    operand :a, Numeric
    operand :b, Numeric

    def execute
      @a + @b
    end
  end

  class Multiply < Rack::RPC::Operation
    operand :a, Numeric
    operand :b, Numeric

    def execute
      @a * @b
    end
  end

  class Service < Rack::RPC::Service
    operator Add
    operator Multiply
  end
end # Calc

use Rack::RPC::Endpoint, Calc::Service.new, :path => '/rpc'
run lambda { |env| [200, {'Content-Type' => 'text/plain', 'Location' => '/rpc'}, []] }
