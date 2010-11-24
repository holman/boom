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

  def test_to_hash
    assert_equal 1, @item.to_hash.size
  end

end
