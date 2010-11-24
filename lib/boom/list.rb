# The List contains many Items. They exist as buckets in which to categorize
# individual Items. The relationship is maintained in a simple array on the
# List-level.
#
module Boom class List
    
    # Public: creates a new List instance in-memory.
    #
    # name - The name of the List. Fails if already used.
    #
    # Returns the unpersisted List instance.
    def initialize(name)
      @items = []
      @name  = name
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


    # Public: Retrieves an item from the list
    #
    # item_name - Name or array index of item
    #
    # Returns the item
    def find_item(item_name)
      if item_name =~ /\[(\d+)\]/
        self.items[$1.to_i]
      else
        self.items.find { |item| item.name == item_name }
      end
    end

    # Public: Deletes an item from the list
    #
    # item_name - Name or array index of item
    #
    def delete_item(item_name)
      if item_name =~ /\[(\d+)\]/
        self.items.delete_at($1.to_i)
      else
        self.items.reject { |item| item.name == item_name }
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
