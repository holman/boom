# coding: utf-8

require 'test/unit'

begin
  require 'rubygems'
  require 'redgreen'
rescue LoadError
end

require 'mocha'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'boom'

def boom_json(name)
  Boom::Storage.any_instance.stubs(:json_file).
    returns("test/examples/#{name}.json")
  Boom.stubs(:storage).returns(Boom::Storage.new)
end
