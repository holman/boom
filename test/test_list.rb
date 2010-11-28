require 'helper'

class TestList < Test::Unit::TestCase

  def setup
    @list = Boom::List.new('urls')
    @item = Boom::Item.new('github','https://github.com')
    boom_json :urls
  end

  def test_name
    assert_equal 'urls', @list.name
  end

  def test_add_items
    assert_equal 0, @list.items.size
    @list.add_item(@item)
    assert_equal 1, @list.items.size
  end

  def test_to_hash
    assert_equal 0, @list.to_hash[@list.name].size
    @list.add_item(@item)
    assert_equal 1, @list.to_hash[@list.name].size
  end

  def test_find
    assert_equal 'urls', Boom::List.find('urls').name
  end

end
