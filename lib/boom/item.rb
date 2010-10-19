module Boom
  class Item
    
    attr_accessor :name
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

    # Public: deletes the Item object.
    #
    # Returns true deletion if successful, false if unsuccessful.
    def delete
    end
    
    # Public: creates a Hash for this Item.
    #
    # Returns a Hash of its data.
    def to_hash
      { @name => @value }
    end

  end
end
