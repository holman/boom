require 'helper'

class TestPlatform < Test::Unit::TestCase

  def setup
  end

  def test_can_handle_percent_strings
    Boom::Platform.expects("system").with("printf \"val%%ue\" | #{Boom::Platform.copy_command}")
    Boom::Platform.copy(Boom::Item.new('name','val%ue'))
  end if !Boom::Platform.windows?

  def test_darwin
    assert_equal Boom::Platform.darwin?, RUBY_PLATFORM.include?('darwin')
  end

  def test_windows
    assert_equal Boom::Platform.windows?, true if RUBY_PLATFORM =~ /mswin|mingw/
  end
end
