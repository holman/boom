# coding: utf-8

# The representation of the base unit in boom. An Item contains just a name and
# a value. It doesn't know its parent relationship explicitly; the parent List
# object instead knows which Items it contains.
#
module Boom
  class Item
    
    # Public: the String name of the Item
    attr_accessor :name

    # Public: the String value of the Item
    attr_accessor :value
    
    # Public: the String additional description of the Item
    attr_accessor :desc

    # Public: creates a new Item object.
    #
    # name  - the String name of the Item
    # value - the String value of the Item
    #
    # Examples
    #
    #   Item.new("github", "https://github.com")
    #   Item.new("github", ["https://github.com", "social coding"])
    #   Item.new("github", "https://github.com", "social coding")
    #
    # Returns the newly initialized Item.
    def initialize(name,*values)
      @name = name
      @value, @desc = values.flatten
    end

    # Public: the shortened String name of the Item. Truncates with ellipses if
    # larger.
    #
    # Examples
    #
    #   item = Item.new("github's home page","https://github.com")
    #   item.short_name
    #   # => 'github's home p…'
    #
    #   item = Item.new("github","https://github.com")
    #   item.short_name
    #   # => 'github'
    #
    # Returns the shortened name.
    def short_name
      name.length > 15 ? "#{name[0..14]}…" : name[0..14]
    end

    # Public: the amount of consistent spaces to pad based on Item#short_name.
    #
    # Returns a String of spaces.
    def spacer
      name.length > 15 ? '' : ' '*(15-name.length+1)
    end

    # Public: creates a Hash for this Item.
    #
    # Returns a Hash of its data.
    def to_hash
      { @name => [@value,@desc].compact }
    end

  end
end
