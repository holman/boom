# coding: utf-8

require 'helper'

class TestConfig < Test::Unit::TestCase

  def setup
    Boom::Config.any_instance.stubs(:file).
      returns("test/examples/test_json.json")

    @config = Boom::Config.new
    @config.stubs(:save).returns(true)
  end

  def test_bootstraps_config
    @config.bootstrap
    assert_equal ({:backend => 'JSON'}), @config.attributes
  end

  def test_attributes
    @config.attributes[:wu_tang] = 'clan'
    assert_equal 'clan', @config.attributes[:wu_tang]
  end

end
