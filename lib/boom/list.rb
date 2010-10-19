module Boom
  class List
    
    # Public: creates a new List object from JSON data structures, including
    # any child Items it contains.
    #
    # Examples
    #
    #   List.create_from_json(json)
    #
    # Returns the List object.
    def self.create_from_json(json)
    end

    # Public: a list of all Lists that boom knows about.
    #
    # Returns an Array of Lists.
    def self.all
    end

    # Public: creates a new List instance in-memory.
    #
    # name - The name of the List. Fails if already used.
    #
    # Returns the unpersisted List instance.
    def initialize(name)
      @items = []
      @name  = name
    end

    # Public: deletes the List object.
    #
    # Returns true deletion if successful, false if unsuccessful.
    def delete
    end

    # Public: lets you access the array of items contained within this List.
    #
    # Returns an Array of Items.
    attr_accessor :items

    attr_accessor :name

    # Public: associates an Item with this List.
    #
    # item - the Item object to associate with this List.
    #
    # Returns the current set of items.
    def add_item(item)
      @items << item
    end

    # Public: a Hash representation of this List.
    #
    # Returns a Hash of its own data and its child Items.
    def to_hash
      { name => items.collect(&:to_hash) }
    end

  end
end
