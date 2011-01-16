class FakeRPCServer < Rack::RPC::Server
  def initialize(options = {}, &block)
    super(options, &block)
  end

  def test
    'ok'
  end
  rpc 'fakerpcserver.test' => :test

  def test_env
    request.params['test']
  end
  rpc 'fakerpcserver.test_env' => :test_env
end
