# coding: utf-8

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

  def self.save!
    # no-op
  end

end

class TestCommand < Test::Unit::TestCase

  def setup
    boom_json :urls
  end

  def command(cmd)
    cmd = cmd.split(' ') if cmd
    Boom::Command.capture_output
    Boom::Command.execute(*cmd)
    Boom::Command.captured_output
  end

  def test_overview
    assert_equal '  urls (3)', command(nil)
  end

  def test_list_detail
    assert_match /github/, command('urls')
  end

  def test_list_all
    cmd = command('all')
    assert_match /urls/,    cmd
    assert_match /github/,  cmd
  end

  def test_list_creation
    assert_match /a new list called "newlist"/, command('newlist')
  end

  def test_item_access
    assert_match /copied https:\/\/github\.com to your clipboard/,
      command('github')
  end

  def test_item_access_scoped_by_list
    assert_match /copied https:\/\/github\.com to your clipboard/,
      command('urls github')
  end

  def test_item_creation
    assert_match /"twitter" in "urls"/,
      command('urls twitter http://twitter.com/holman')
  end

  def test_list_deletion_no
    STDIN.stubs(:gets).returns('n')
    assert_match /Just kidding then/, command('urls delete')
  end

  def test_list_deletion_yes
    STDIN.stubs(:gets).returns('y')
    assert_match /Deleted all your urls/, command('urls delete')
  end

  def test_item_deletion
    assert_match /"github" is gone forever/, command('urls github delete')
  end

  def test_edit
    Boom::Command.stubs(:system).returns('')
    assert_match 'Make your edits', command('edit')
  end

  def test_help
    assert_match 'boom help', command('help')
    assert_match 'boom help', command('-h')
    assert_match 'boom help', command('--help')
  end

  def test_noop_options
    assert_match 'boom help', command('--anything')
    assert_match 'boom help', command('-d')
  end

  def test_nonexistent_item_access_scoped_by_list
    assert_match /"twitter" not found in "urls"/, command('urls twitter')
  end
  
  def test_item_creation_with_desc
    assert_match /"twitter" in "urls"/, command('urls twitter http://twitter.com/holman he taps code for GitHub:FI')
    assert_match %r{twitter:\s+http://twitter.com/holman he taps code for GitHub:FI}, command('urls')
    assert_match %r{desc:\s+http://en.wiktionary.org/wiki/description the description}, command('urls')    
  end
end
