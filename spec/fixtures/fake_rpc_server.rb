  class FakeRPCServer < Rack::RPC::Server
    def initialize(options = {}, &block)
      super(options, &block)
    end

    def test
      'ok'
    end
    rpc 'fakerpcserver.test' => :test
  end
