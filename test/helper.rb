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
  root = File.expand_path(File.dirname(__FILE__))
  Boom::Storage::Json.any_instance.stubs(:save).returns(true)
  Boom::Storage::Json.any_instance.stubs(:json_file).
    returns("#{root}/examples/#{name}.json")
  Boom.use_remote false
  Boom.stubs(:storage).returns(Boom::Storage::Json.new)
end
