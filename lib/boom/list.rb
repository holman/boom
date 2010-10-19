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
    end

    # Public: deletes the List object.
    #
    # Returns true deletion if successful, false if unsuccessful.
    def delete
    end

    # Public: lets you access the array of items contained within this List.
    #
    # Returns an Array of Items.
    def items
    end

    # Public: creates a JSON data structure for this List.
    #
    # Returns a String of its own data and its child Items in JSON format.
    def to_json
      items.collect(&:to_json)
    end

  end
end
