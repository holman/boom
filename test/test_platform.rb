require 'helper'

class TestPlatform < Test::Unit::TestCase

  def setup
  end

  def test_darwin
    assert_equal Boom::Platform.darwin?, RUBY_PLATFORM.include?('darwin')
  end

  def test_windows
    assert_equal Boom::Platform.windows?, true if RUBY_PLATFORM =~ /win|mingw/ 
  end
end
