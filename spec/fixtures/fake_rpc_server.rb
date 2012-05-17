class FakeRPCServer < Rack::RPC::Server
  def initialize(options = {}, &block)
    super(options, &block)
  end

  def test
    'ok'
  end
  rpc 'fakerpcserver.test' => :test

  def test_env
    STDERR.puts "Request: #{request.inspect}"
    STDERR.puts "Params: #{request.params.inspect}"
    result = request.params['test']
    STDERR.puts "Result: = #{result}"
    result
  end
  rpc 'fakerpcserver.test_env' => :test_env
end
