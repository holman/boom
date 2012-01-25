# coding: utf-8

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

  def test_url
    assert_equal 'https://github.com', @item.url
  end

  def test_url_with_additional_description
    @item = Boom::Item.new('github', 'social coding https://github.com')
    assert_equal 'https://github.com', @item.url
  end

  def test_url_without_url
    @item = Boom::Item.new('didum', 'dadam lol omg')
    assert_equal 'dadam lol omg', @item.url
  end

  def test_move_item_to_new_list
    new_list_name = "urls"

    @item.move(new_list_name)
    @list = Boom::List.find(new_list_name)

    assert_equal 1, @list.items.size
  end

  def test_move_item_to_existing_list
    @list_2 = Boom::List.new('sexy-companies')

    @item.move(@list_2.name)

    assert_equal 1, @list_2.items.size
    assert_equal 0, @list.items.size
  end

end
