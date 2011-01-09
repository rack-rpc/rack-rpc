#!/usr/bin/env ruby
$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'lib')))
require 'rubygems'
begin
  require 'rakefile' # http://github.com/bendiken/rakefile
rescue LoadError => e
end
require 'rack/rpc'


# Setup RSpec tasks
require 'rspec/core'
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new do |t|
  t.pattern = "./**/*_spec.rb"
end

task :default => :spec
