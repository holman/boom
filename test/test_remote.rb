# coding: utf-8

require 'helper'
require 'output_interceptor'
require 'ruby-debug'
require 'ostruct'

class TestRemote < Test::Unit::TestCase
  def dummy type
    m = stub 'storage_type', :class => type
  end

  def test_remote
    Boom.use_remote false
    Boom::Output.capture_output

    local  = [Boom::Storage::Json, Boom::Storage::Keychain ]


    remote = [Boom::Storage::Gist, Boom::Storage::Mongodb, Boom::Storage::Redis]

    (local + remote).all? do |type|
      assert Boom::Remote.allowed? dummy(type)
    end

    Boom.use_remote true

    Boom::Remote.stubs(:output)
    remote.all? { |t| assert Boom::Remote.allowed?(dummy(t)), "#{t} should be allowed" }
    local.all?  { |t| refute Boom::Remote.allowed?(dummy(t)), "#{t} should not be allowed"}
  end
end
