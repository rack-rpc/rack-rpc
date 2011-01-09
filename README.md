JSON-RPC/XML-RPC Server for Rack Applications
=============================================

* <http://github.com/datagraph/rack-rpc>

Filters
=======

Rack RPC also provides Rails style controller filtering via
"before_filter" and "after_filter" declarations in your server.

    before_filter :check_auth, :only => :authorized_only
    after_filter :log_something, :except => :non_logged_method
    before_filter :another_test_filter do
      # Can take an optional block instead of a method name
    end

You can halt execution in a filter by raising an exception. An error
response will be returned with the exception's message set as the error
object message.

