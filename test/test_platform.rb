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
  
  def test_open_for_not_windows
    Boom::Platform.stubs(:windows?).returns(true)
    Boom::Platform.expects(:system).with("open http://example.com")
    
    item = mock(:url => "http://example.com", :value => "http://example.com")
    Boom::Platform.open(item)
  end

  def test_open_for_windows
    Boom::Platform.stubs(:windows?).returns(false)
    Boom::Platform.expects(:system).with("open 'http://example.com'")
    
    item = mock(:url => "http://example.com", :value => "http://example.com")
    Boom::Platform.open(item)
  end

  def test_copy_command_darwin
    Boom::Platform.stubs(:darwin?).returns(true)
    Boom::Platform.stubs(:windows?).returns(false)
    assert_equal Boom::Platform.copy_command, 'pbcopy'
  end

  def test_copy_command_windows
    Boom::Platform.stubs(:windows?).returns(true)
    Boom::Platform.stubs(:darwin?).returns(false)
    assert_equal Boom::Platform.copy_command, 'clip'
  end

  def test_copy_command_darwin
    Boom::Platform.stubs(:darwin?).returns(false)
    Boom::Platform.stubs(:darwin?).returns(false)
    assert_equal Boom::Platform.copy_command, 'xclip -selection clipboard'
  end
  
end
