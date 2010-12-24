# The List contains many Items. They exist as buckets in which to categorize
# individual Items. The relationship is maintained in a simple array on the
# List-level.
#
module Boom
  class List
    
    # Public: creates a new List instance in-memory.
    #
    # name - The name of the List. Fails if already used.
    #
    # Returns the unpersisted List instance.
    def initialize(name)
      @items = []
      @name  = name
    end

    # Public: accesses the in-memory JSON representation.
    #
    # Returns a Storage instance.
    def self.storage
      Boom.storage
    end

    # Public: lets you access the array of items contained within this List.
    #
    # Returns an Array of Items.
    attr_accessor :items

    # Public: the name of the List.
    #
    # Returns the String name.
    attr_accessor :name

    # Public: associates an Item with this List.
    #
    # item - the Item object to associate with this List.
    #
    # Returns the current set of items.
    def add_item(item)
      @items << item
    end

    # Public: finds any given List by name.
    #
    # name - String name of the list to search for
    #
    # Returns the first instance of List that it finds.
    def self.find(name)
      storage.lists.find { |list| list.name == name } 
    end

    # Public: deletes a List by name.
    #
    # name - String name of the list to delete
    #
    # Returns whether one or more lists were removed.
    def self.delete(name)
      previous = storage.lists.size
      storage.lists = storage.lists.reject { |list| list.name == name }
      previous != storage.lists.size
    end

    # Public: deletes an Item by name.
    #
    # name - String name of the item to delete
    #
    # Returns whether an item was removed.
    def delete_item(name)
      previous = items.size
      items.reject! { |item| item.name == name}
      previous != items.size
    end

    # Public: finds an Item by name. If the name is typically truncated, also
    # allow a search based on that truncated name.
    #
    # name - String name of the Item to find
    #
    # Returns the found item
    def find_item(name)
      items.find do |item|
        item.name == name ||
        item.short_name.gsub('…','') == name.gsub('…','')
      end
    end

    # Public: a Hash representation of this List.
    #
    # Returns a Hash of its own data and its child Items.
    def to_hash
      { name => items.collect(&:to_hash) }
    end

  end
end
