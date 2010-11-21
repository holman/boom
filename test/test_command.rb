require 'helper'

# Intercept STDOUT and collect it
class Boom::Command
  def self.capture_output
    @output = ''
  end

  def self.captured_output
    @output
  end

  def self.output(s)
    @output << s
  end
end

class TestCommand < Test::Unit::TestCase

  def setup
    Boom::Storage.any_instance.expects(:json_file).
      returns('test/examples/urls.json')
    @storage = Boom::Storage.new
  end

  def command(cmd)
    Boom::Command.capture_output
    Boom::Command.execute(@storage,cmd)
    Boom::Command.captured_output
  end

  def test_overview
    assert_equal '  urls (2)', command(nil)
  end

  def test_list_detail
    assert_match /github/, command('urls')
  end

  def test_list_creation
    assert_match /a new list called "newlist"/, command('newlist')
  end
end
