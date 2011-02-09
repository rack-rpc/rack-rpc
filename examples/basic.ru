# This represents the most basic RPC Server that you can make with
# Rack-RPC. All invalid requests will return a 404, "Not found"
# Test from the command line with:
#   curl -H "Content-Type: application/json" \
#     -d '{ "jsonrpc": "2.0", "method": "hello_world", "params": [], "id":2 }' \
#     http://localhost:9292/rpc

require 'rack/rpc'

class Server < Rack::RPC::Server
  def hello_world
    "Hello, world!"
  end
  rpc 'hello_world' => :hello_world
end

app = lambda do |env|
  [404, {"Content-Type" => "text/plain"}, ["Not found"]]
end

use Rack::RPC::Endpoint, Server.new

run app
