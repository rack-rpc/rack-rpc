#!/usr/bin/env ruby -rubygems
# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.version            = File.read('VERSION').chomp
  gem.date               = File.mtime('VERSION').strftime('%Y-%m-%d')

  gem.name               = 'rack-rpc'
  gem.homepage           = 'http://github.com/datagraph'
  gem.license            = 'Public Domain' if gem.respond_to?(:license=)
  gem.summary            = 'JSON-RPC/XML-RPC server for Rack applications.'
  gem.description        = 'Rack middleware for serving up RPC endpoints.'
  gem.rubyforge_project  = 'datagraph'

  gem.author             = 'Datagraph'
  gem.email              = 'datagraph@googlegroups.com'

  gem.platform           = Gem::Platform::RUBY
  gem.files              = %w(AUTHORS CREDITS README UNLICENSE VERSION) + Dir.glob('lib/**/*.rb')
  gem.bindir             = %q(bin)
  gem.executables        = %w()
  gem.default_executable = gem.executables.first
  gem.require_paths      = %w(lib)
  gem.extensions         = %w()
  gem.test_files         = %w()
  gem.has_rdoc           = false

  gem.required_ruby_version      = '>= 1.8.1'
  gem.requirements               = []
  gem.add_runtime_dependency     'rack',      '>= 1.0'
  gem.add_development_dependency 'nokogiri',  '>= 1.4.4'
  gem.add_development_dependency 'yard' ,     '>= 0.6.0'
  gem.add_development_dependency 'rspec',     '>= 2.1.0'
  gem.add_development_dependency 'rack-test', '>= 0.5.6'
  gem.post_install_message       = nil
end
