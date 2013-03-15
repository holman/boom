# coding: utf-8

# The representation of the base unit in boom. An Item contains just a name and
# a value. It doesn't know its parent relationship explicitly; the parent List
# object instead knows which Items it contains.
#
module Boom
  class Item
    # Public: the String value of the Item
    attr_accessor :value

    # Public: creates a new Item object.
    #
    # value - the String value of the Item
    #
    # Examples
    #
    #   Item.new("https://github.com")
    #
    # Returns the newly initialized Item.
    def initialize(value)
      @value = value
    end

    # Public: the shortened String value of the Item. Truncates with ellipses if
    # larger.
    #
    # Examples
    #
    #   item = Item.new("github's home page","https://github.com")
    #   item.short_value
    #   # => 'github's home p…'
    #
    #   item = Item.new("github","https://github.com")
    #   item.short_value
    #   # => 'github'
    #
    # Returns the shortened name.
    def short_value
      value.length > 15 ? "#{value[0..14]}…" : value[0..14]
    end

    # Public: the amount of consistent spaces to pad based on Item#short_value.
    #
    # Returns a String of spaces.
    def spacer
      value.length > 15 ? '' : ' '*(15-value.length+1)
    end

    # Public: only return url part of value - if no url has been
    # detected it'll return the value.
    #
    # Returns a String which preferably is a URL.
    def url
      @url ||= value.split(/\s+/).detect { |v| v =~ %r{\A[a-z0-9]+:\S+}i } || value
    end
  end
end