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

    # Public: creates a new Item object.
    #
    # name  - the String name of the Item
    # value - the String value of the Item
    #
    # Examples
    #
    #   Item.new("github", "http://github.com")
    #
    # Returns the newly initialized Item.
    def initialize(name,value)
      @name = name
      @value = value
    end

    # Public: creates a Hash for this Item.
    #
    # Returns a Hash of its data.
    def to_hash
      { @name => @value }
    end

  end
end
