JSON-RPC/XML-RPC Server for Rack Applications [![Build Status](https://secure.travis-ci.org/threez/rack-rpc.png?branch=master)](http://travis-ci.org/threez/rack-rpc)
=============================================

This is a [Rack][] middleware that facilitates the creation of
protocol-agnostic RPC servers. The current implementation provides support
for [JSON-RPC 2.0][] and [XML-RPC][].

* <https://github.com/datagraph/rack-rpc>

Features
--------

* Handles JSON-RPC and XML-RPC requests with the same code.
* Compatible with any Rack application and any Rack-based framework.
* Provides Rails-style controller filtering for your RPC methods.

Examples
--------

### A basic RPC server

    require 'rack/rpc'
    
    class Server < Rack::RPC::Server
      def hello_world
        "Hello, world!"
      end
      rpc 'hello_world' => :hello_world
    end

### Simple filtering

    require 'rack/rpc'
    
    class Server < Rack::RPC::Server
      before_filter :check_auth

      def hello_world
        "Hello, world!"
      end
      rpc 'hello_world' => :hello_world

      private

      def check_auth
        raise "Not authorized" unless authorized
      end
    end

### Filtering via a proc with more options

    require 'rack/rpc'
    
    class Server < Rack::RPC::Server
      before_filter :check_auth, :only => :super_secret_hello_world do
        raise "Not authorized" unless authorized
      end

      def hello_world
        "Hello, world!"
      end
      rpc 'hello_world' => :hello_world

      def super_secret_hello_world
        'super_secret_hello_world'
      end
      rpc 'super_secret_hello_world' => :super_secret_hello_world
    end

### Running the server

    # config.ru
    use Rack::RPC::Endpoint, Server.new
    
    run MyApplication

### Customizing the default RPC path

    # config.ru
    use Rack::RPC::Endpoint, Server.new, :path => '/api'
    
    run MyApplication

More on Filters
---------------

The `:only` and `:except` options for filters can take a single method or an
array of methods.

You can halt execution in a filter by raising an exception. An error
response will be returned with the exception's message set as the error
object's message text.

Communicationg with the Server
------------------------------

By default, methods will only be invoked on `POST` requests to "/rpc". The
default path can be overridden by sending a `:path` option when creating
your middleware (see example above).

The protocol used is determined by the `CONTENT_TYPE` header
("application/xml" and "text/xml" for XML and "application/json" for JSON).

Dependencies
------------

* [Rack](http://rubygems.org/gems/rack) (>= 1.0.0)
* [Builder](http://rubygems.org/gems/builder) (>= 2.1.2)

Installation
------------

The recommended installation method is via [RubyGems](http://rubygems.org/).
To install the latest official release of the gem, do:

    % [sudo] gem install rack-rpc

Download
--------

To get a local working copy of the development repository, do:

    % git clone git://github.com/datagraph/rack-rpc.git

Alternatively, download the latest development version as a tarball as
follows:

    % wget http://github.com/datagraph/rack-rpc/tarball/master

Mailing List
------------

* <http://groups.google.com/group/rack-devel>

Authors
-------

* [Arto Bendiken](https://github.com/bendiken) - <http://ar.to/>
* [Josh Huckabee](https://github.com/jhuckabee) - <http://joshhuckabee.com/>

License
-------

This is free and unencumbered public domain software. For more information,
see <http://unlicense.org/> or the accompanying {file:UNLICENSE} file.

[Rack]:           http://rack.rubyforge.org/
[JSON-RPC 2.0]:   http://groups.google.com/group/json-rpc/web/json-rpc-2-0
[XML-RPC]:        http://www.xmlrpc.com/
