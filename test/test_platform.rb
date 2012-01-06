require 'helper'

class TestPlatform < Test::Unit::TestCase

  def setup

  end

  def test_darwin
    assert_equal Boom::Platform.darwin?, RUBY_PLATFORM.include?('darwin')
  end

  def test_windows
    assert_equal Boom::Platform.windows?, true if RUBY_PLATFORM =~ /mswin|mingw/
  end
  
  def test_open_command_darwin
    Boom::Platform.stubs(:darwin?).returns(true)
    assert_equal Boom::Platform.open_command, 'open'
  end
  
  def test_open_command_windows
    Boom::Platform.stubs(:darwin?).returns(false)
    Boom::Platform.stubs(:windows?).returns(true)
    assert_equal Boom::Platform.open_command, 'start'
  end
  
  def test_open_command_linux
    Boom::Platform.stubs(:darwin?).returns(false)
    Boom::Platform.stubs(:windows?).returns(false)
    assert_equal Boom::Platform.open_command, 'xdg-open'
  end

  def test_copy_command_darwin
    Boom::Platform.stubs(:darwin?).returns(true)
    Boom::Platform.stubs(:windows?).returns(false)
    assert_equal Boom::Platform.copy_command, 'pbcopy'
  end

  def test_copy_command_windows
    Boom::Platform.stubs(:darwin?).returns(true)
    Boom::Platform.stubs(:windows?).returns(false)
    assert_equal Boom::Platform.copy_command, 'clip'
  end

  def test_copy_command_linux
    Boom::Platform.stubs(:darwin?).returns(false)
    Boom::Platform.stubs(:windows?).returns(false)
    assert_equal Boom::Platform.copy_command, 'xclip -selection clipboard'
  end
  
end
