#!/usr/bin/env ruby -rubygems
# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.version            = File.read('VERSION.txt').chomp
  gem.date               = File.mtime('VERSION.txt').strftime('%Y-%m-%d')

  gem.name               = 'rack-rpc'
  gem.homepage           = 'https://github.com/rack-rpc/rack-rpc'
  gem.license            = 'Public Domain' if gem.respond_to?(:license=)
  gem.summary            = 'JSON-RPC/XML-RPC server for Rack applications.'
  gem.description        = 'Rack middleware for serving RPC endpoints.'

  gem.authors            = ['Arto Bendiken', 'Josh Huckabee', 'Vincent Landgraf']
  gem.email              = 'pieterb@djinnit.com'

  gem.platform           = Gem::Platform::RUBY
  gem.files              = %w(AUTHORS.md README.md UNLICENSE.md VERSION.txt) + Dir.glob('lib/**/*.rb')
  gem.require_paths      = %w(lib)
  gem.test_files         = %w()

  gem.required_ruby_version      = '>= 1.8.7'
  gem.requirements               = []
  gem.add_runtime_dependency     'builder',   '>= 2.1.2'
  gem.add_runtime_dependency     'rack',      '>= 1.0'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'json',      '~> 1.7.3'
  gem.add_development_dependency 'nokogiri',  '>= 1.4.4'
  gem.add_development_dependency 'yard',      '>= 0.6.0'
  gem.add_development_dependency 'redcarpet', '>= 3.1.0'
  gem.add_development_dependency 'rspec',     '>= 2.1.0'
  gem.add_development_dependency 'rack-test', '>= 0.5.6'
  gem.add_development_dependency 'travis-lint'
  gem.post_install_message       = nil
end
