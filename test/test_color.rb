# coding: utf-8

require 'helper'

class TestColor < Test::Unit::TestCase

  def test_colorize
    assert_equal "\e[35mBoom!\e[0m",
      Boom::Color.colorize("Boom!", :magenta)
  end

  def test_magenta
    assert_equal "\e[35mMagenta!\e[0m",
      Boom::Color.magenta("Magenta!")
  end

  def test_red
    assert_equal "\e[31mRed!\e[0m",
      Boom::Color.red("Red!")
  end

  def test_yellow
    assert_equal "\e[33mYellow!\e[0m",
      Boom::Color.yellow("Yellow!")
  end
end
