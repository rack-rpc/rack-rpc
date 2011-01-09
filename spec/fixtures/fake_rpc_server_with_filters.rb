class FakeRPCServerWithFilters < Rack::RPC::Server
  attr_accessor :test_method_one_called, :test_method_two_called, :test_method_three_called

  def initialize(options = {}, &block)
    super(options, &block)
    @test_method_one_called = false
    @test_method_two_called = false
    @test_method_three_called = false
  end

  def test_method_one
    @test_method_one_called = true
    'test_method_one'
  end
  rpc 'fakerpcserverwithfilters.test_method_one' => :test_method_one

  def test_method_two
    @test_method_two_called = true
    'test_method_two'
  end
  rpc 'fakerpcserverwithfilters.test_method_two' => :test_method_two

  def test_method_three
    @test_method_three_called = true
    'three'
  end
  rpc 'fakerpcserverwithfilters.test_method_three' => :test_method_three
end
