require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'Rack::RPC::VERSION' do
  it "should match the VERSION file" do
    Rack::RPC::VERSION.to_s.should == File.read(File.join(File.dirname(__FILE__), '..', 'VERSION.txt')).chomp
  end
end
