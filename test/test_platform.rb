require 'helper'

class TestPlatform < Test::Unit::TestCase

  def setup
  end

  def test_darwin
    assert_equal Boom::Platform.darwin?, RUBY_PLATFORM.include?('darwin')
  end
end
