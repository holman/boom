require 'helper'

class Boom::Command
  # Intercept STDOUT and collect it
  def self.output(s)
    @saved_output ||= ''
    @saved_output << s
  end

  def self.saved_output
    @saved_output
  end
end

class TestCommand < Test::Unit::TestCase

  def setup
    Boom::Storage.any_instance.expects(:json_file).
      returns('test/examples/urls.json')
    @storage = Boom::Storage.new
  end

  def command(cmd)
    Boom::Command.execute(@storage,cmd)
    Boom::Command.saved_output
  end

  def test_overview
    assert_equal '  urls (2)', command(nil)
  end
end
