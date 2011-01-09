require File.join(File.dirname(__FILE__), 'spec_helper')

describe Rack::RPC::Server do
  it "maps rpc method names to instance methods" do
    FakeRPCServer.rpc['fakerpcserver.test'].should == :test
    FakeRPCServer.rpc['fakerpcserver.some_unknown_method'].should == nil
  end

  describe "before filters" do
    describe "with a given method name" do
      describe "and no options" do
        it "should execute the given method" do
          class BeforeFilterNoOptionsMethodSuccess < FakeRPCServerWithFilters
            before_filter :before_method_one
            attr_accessor :before_method_one_called
            def before_method_one
              @before_method_one_called = true
              true
            end
          end
          @server = BeforeFilterNoOptionsMethodSuccess.new
          @server.test_method_one
          @server.before_method_one_called.should be_true
          @server.test_method_one_called.should be_true
        end
      end

      describe "with only options specified" do
        it "should only execute the method if the method name matches the only option" do
          class BeforeFilterOnlyOptionsMethodSuccess < FakeRPCServerWithFilters
            before_filter :before_method_one, :only => :test_method_one
            attr_accessor :before_method_one_called
            def before_method_one
              @before_method_one_called = true
              true
            end
          end
          @server = BeforeFilterOnlyOptionsMethodSuccess.new
          @server.test_method_one
          @server.before_method_one_called.should be_true
          @server.test_method_one_called.should be_true
          @server.before_method_one_called = false
          @server.test_method_one_called = false
          @server.test_method_two
          @server.test_method_one_called.should be_false
          @server.test_method_one_called.should be_false
        end

        it "should only execute the method if the method is in the only options array" do
          class BeforeFilterOnlyArrayOptionsMethodSuccess < FakeRPCServerWithFilters
            before_filter :before_method_general, :only => [:test_method_one, :test_method_two]
            attr_accessor :before_method_general_called
            def before_method_general
              @before_method_general_called = true
              true
            end
          end
          @server = BeforeFilterOnlyArrayOptionsMethodSuccess.new
          @server.test_method_one
          @server.before_method_general_called.should be_true
          @server.test_method_one_called.should be_true
          @server.before_method_general_called = false
          @server.test_method_two
          @server.before_method_general_called.should be_true
          @server.test_method_two_called.should be_true
        end
      end

      describe "with :except option specified" do
        it "should not execute the method if the method is specified in options" do
          class BeforeFilterExceptOptionsMethodSuccess < FakeRPCServerWithFilters
            before_filter :before_method_general, :except => :test_method_one
            attr_accessor :before_method_general_called
            def initialize
              @before_method_general_called = false
            end
            def before_method_general
              @before_method_general_called = true
              true
            end
          end
          @server = BeforeFilterExceptOptionsMethodSuccess.new
          @server.test_method_one
          @server.before_method_general_called.should be_false
          @server.test_method_one_called.should be_true
          @server.test_method_two
          @server.before_method_general_called.should be_true
          @server.test_method_two_called.should be_true
        end

        it "should not execute the method if the method is specified in the options array" do
          class BeforeFilterExceptArrayOptionsMethodSuccess < FakeRPCServerWithFilters
            before_filter :before_method_general, :except => [:test_method_one, :test_method_two]
            attr_accessor :before_method_general_called
            def initialize
              @before_method_general_called = false
            end
            def before_method_general
              @before_method_general_called = true
              true
            end
          end
          @server = BeforeFilterExceptArrayOptionsMethodSuccess.new
          @server.test_method_one
          @server.before_method_general_called.should be_false
          @server.test_method_one_called.should be_true
          @server.test_method_two
          @server.before_method_general_called.should be_false
          @server.test_method_two_called.should be_true
        end
      end
    end

    # Using a proc
    describe 'with given proc' do
      describe 'and no options' do
        it "should execute the given method name" do
          class BeforeFilterNoOptionsProcSuccess < FakeRPCServerWithFilters
            attr_accessor :before_method_one_called

            def initialize
              @before_method_one_called = false
            end

            before_filter :before_method_one do
              @before_method_one_called = true  
              true
            end
          end
          @server = BeforeFilterNoOptionsProcSuccess.new
          @server.test_method_one
          @server.before_method_one_called.should be_true
          @server.test_method_one_called.should be_true
        end
      end

      describe "with only options specified" do
        it "should only execute the method if the method name matches the only option" do
          class BeforeFilterOnlyOptionsProcSuccess < FakeRPCServerWithFilters
            attr_accessor :before_method_one_called
            before_filter :before_method_one, :only => :test_method_one do
              @before_method_one_called = true
              true
            end
          end
          @server = BeforeFilterOnlyOptionsProcSuccess.new
          @server.test_method_one
          @server.before_method_one_called.should be_true
          @server.test_method_one_called.should be_true
          @server.test_method_one_called = false
          @server.test_method_two
          @server.test_method_one_called.should be_false
        end

        it "should only execute the method if the method name is in the options array" do
          class BeforeFilterOnlyArrayOptionsProcSuccess < FakeRPCServerWithFilters
            attr_accessor :before_method_general_called
            before_filter :before_method_general, :only => [:test_method_one, :test_method_two] do
              @before_method_general_called = true
              true
            end
          end
          @server = BeforeFilterOnlyArrayOptionsProcSuccess.new
          @server.test_method_one
          @server.before_method_general_called.should be_true
          @server.test_method_one_called.should be_true
          @server.before_method_general_called = false
          @server.test_method_two
          @server.test_method_two_called.should be_true
          @server.before_method_general_called.should be_true
        end
      end
    end
  end

  describe "after filters" do
    describe "with a given method name" do
      describe "and no options" do
        it "should execute the given method" do
          class AfterFilterNoOptionsMethodSuccess < FakeRPCServerWithFilters
            after_filter :after_method_one
            attr_accessor :after_method_one_called
            def after_method_one
              @after_method_one_called = true
              true
            end
          end
          @server = AfterFilterNoOptionsMethodSuccess.new
          @server.test_method_one
          @server.after_method_one_called.should be_true
          @server.test_method_one_called.should be_true
        end
      end

      describe "with :only options specified" do
        it "should only execute the method if the method name matches the only option" do
          class AfterFilterOnlyOptionsMethodSuccess < FakeRPCServerWithFilters
            after_filter :after_method_one, :only => :test_method_one
            attr_accessor :after_method_one_called
            def after_method_one
              @after_method_one_called = true
              true
            end
          end
          @server = AfterFilterOnlyOptionsMethodSuccess.new
          @server.test_method_one
          @server.after_method_one_called.should be_true
          @server.test_method_one_called.should be_true
          @server.after_method_one_called = false
          @server.test_method_one_called = false
          @server.test_method_two
          @server.test_method_one_called.should be_false
          @server.test_method_one_called.should be_false
        end

        it "should only execute the method if the method is in the only options array" do
          class AfterFilterOnlyArrayOptionsMethodSuccess < FakeRPCServerWithFilters
            after_filter :after_method_general, :only => [:test_method_one, :test_method_two]
            attr_accessor :after_method_general_called
            def after_method_general
              @after_method_general_called = true
              true
            end
          end
          @server = AfterFilterOnlyArrayOptionsMethodSuccess.new
          @server.test_method_one
          @server.after_method_general_called.should be_true
          @server.test_method_one_called.should be_true
          @server.after_method_general_called = false
          @server.test_method_two
          @server.after_method_general_called.should be_true
          @server.test_method_two_called.should be_true
        end
      end

      describe "with :except option specified" do
        it "should not execute the method if the method is specified in options" do
          class AfterFilterExceptOptionsMethodSuccess < FakeRPCServerWithFilters
            after_filter :after_method_general, :except => :test_method_one
            attr_accessor :after_method_general_called
            def initialize
              @after_method_general_called = false
            end
            def after_method_general
              @after_method_general_called = true
              true
            end
          end
          @server = AfterFilterExceptOptionsMethodSuccess.new
          @server.test_method_one
          @server.after_method_general_called.should be_false
          @server.test_method_one_called.should be_true
          @server.test_method_two
          @server.after_method_general_called.should be_true
          @server.test_method_two_called.should be_true
        end

        it "should not execute the method if the method is specified in the options array" do
          class AfterFilterExceptArrayOptionsMethodSuccess < FakeRPCServerWithFilters
            after_filter :after_method_general, :except => [:test_method_one, :test_method_two]
            attr_accessor :after_method_general_called
            def initialize
              @after_method_general_called = false
            end
            def after_method_general
              @after_method_general_called = true
              true
            end
          end
          @server = AfterFilterExceptArrayOptionsMethodSuccess.new
          @server.test_method_one
          @server.after_method_general_called.should be_false
          @server.test_method_one_called.should be_true
          @server.test_method_two
          @server.after_method_general_called.should be_false
          @server.test_method_two_called.should be_true
        end
      end
    end

    # Using a proc
    describe 'with given proc' do
      describe 'and no options' do
        it "should execute the given method name" do
          class AfterFilterNoOptionsProcSuccess < FakeRPCServerWithFilters
            attr_accessor :after_method_one_called

            def initialize
              @after_method_one_called = false
            end

            after_filter :after_method_one do
              @after_method_one_called = true  
              true
            end
          end
          @server = AfterFilterNoOptionsProcSuccess.new
          @server.test_method_one
          @server.after_method_one_called.should be_true
          @server.test_method_one_called.should be_true
        end
      end

      describe "with :only options specified" do
        it "should only execute the method if the method name matches the only option" do
          class AfterFilterOnlyOptionsProcSuccess < FakeRPCServerWithFilters
            attr_accessor :after_method_one_called
            after_filter :after_method_one, :only => :test_method_one do
              @after_method_one_called = true
              true
            end
          end
          @server = AfterFilterOnlyOptionsProcSuccess.new
          @server.test_method_one
          @server.after_method_one_called.should be_true
          @server.test_method_one_called.should be_true
          @server.test_method_one_called = false
          @server.test_method_two
          @server.test_method_one_called.should be_false
        end

        it "should only execute the method if the method name is in the options array" do
          class AfterFilterOnlyArrayOptionsProcSuccess < FakeRPCServerWithFilters
            attr_accessor :after_method_general_called
            after_filter :after_method_general, :only => [:test_method_one, :test_method_two] do
              @after_method_general_called = true
              true
            end
          end
          @server = AfterFilterOnlyArrayOptionsProcSuccess.new
          @server.test_method_one
          @server.after_method_general_called.should be_true
          @server.test_method_one_called.should be_true
          @server.after_method_general_called = false
          @server.test_method_two
          @server.test_method_two_called.should be_true
          @server.after_method_general_called.should be_true
        end
      end
    end
  end
  
end
