# coding: utf-8

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

  def test_add_item_with_duplicate_name
    @list.add_item(@item)
    assert_equal 1, @list.items.size
    assert_equal 'https://github.com', @list.find_item('github').value
    @diff_item = Boom::Item.new('github', 'https://github.com/home')
    @list.add_item(@diff_item)
    assert_equal 1, @list.items.size
    assert_equal 'https://github.com/home', @list.find_item('github').value
  end

  def test_to_hash
    assert_equal 0, @list.to_hash[@list.name].size
    @list.add_item(@item)
    assert_equal 1, @list.to_hash[@list.name].size
  end

  def test_find
    assert_equal 'urls', Boom::List.find('urls').name
  end

  def test_find_item
    @list.add_item(@item)
    assert_equal 'https://github.com', @list.find_item('github').value
  end

  def test_find_item_long_name
    @item = Boom::Item.new('long-long-long-name','longname')
    @list.add_item(@item)
    assert_equal 'longname', @list.find_item('long-long-long-').value
    assert_equal 'longname', @list.find_item('long-long-long-…').value
  end

  def test_delete_success
    assert_equal 1, Boom.storage.lists.size
    assert Boom::List.delete('urls')
    assert_equal 0, Boom.storage.lists.size
  end

  def test_delete_fail
    assert_equal 1, Boom.storage.lists.size
    assert !Boom::List.delete('robocop')
    assert_equal 1, Boom.storage.lists.size
  end

  def test_deletes_scoped_to_list
    @list.add_item(@item)

    @list_2 = Boom::List.new('sexy-companies')
    @item_2 = Boom::Item.new(@item.name, @item.value)
    @list_2.add_item(@item_2)

    @list.delete_item(@item.name)
    assert_equal 0, @list.items.size
    assert_equal 1, @list_2.items.size
  end

end
