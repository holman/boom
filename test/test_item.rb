require 'helper'

class TestItem < Test::Unit::TestCase

  def setup
    @item = Boom::Item.new('github','https://github.com')
  end

  def test_name
    assert_equal 'github', @item.name
  end

  def test_value
    assert_equal 'https://github.com', @item.value
  end

  def test_short_name
    assert_equal 'github', @item.short_name
  end

  def test_short_name
    @item.name = 'github github github lol lol lol'
    assert_equal 'github github g…', @item.short_name
  end

  def test_spacer_none
    @item.name = 'github github github lol lol lol'
    assert_equal '', @item.spacer
  end

  def test_spacer_tons
    assert_equal '          ', @item.spacer
  end

  def test_to_hash
    assert_equal 1, @item.to_hash.size
  end

end
