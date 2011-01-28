# coding: utf-8

# Storage is the middleman between changes the client makes in-memory and how
# it's actually persisted to disk (and vice-versa). There are also a few
# convenience methods to run searches and operations on the in-memory hash.
#
module Boom
  module Storage
    class Base

      # Public: initializes a Storage instance by loading in your persisted data from adapter.
      #
      # Returns the Storage instance.
      def initialize
        @lists = []
        bootstrap
        setup
      end

      # Public: the in-memory collection of all Lists attached to this Storage
      # instance.
      #
      # lists - an Array of individual List items
      #
      # Returns nothing.
      attr_writer :lists

      # Public: the list of Lists in your JSON data, sorted by number of items
      # descending.
      #
      # Returns an Array of List objects.
      def lists
        @lists.sort_by { |list| -list.items.size }
      end

      # Public: saving in-memory data to any adapter
      #
      # Returns true or false
      def save!
        save
      end

      # Public: tests whether a named List exists.
      #
      # name - the String name of a List
      #
      # Returns true if found, false if not.
      def list_exists?(name)
        @lists.detect { |list| list.name == name }
      end

      # Public: all Items in storage.
      #
      # Returns an Array of all Items.
      def items
        @lists.collect(&:items).flatten
      end

      # Public: tests whether a named Item exists.
      #
      # name - the String name of an Item
      #
      # Returns true if found, false if not.
      def item_exists?(name)
        items.detect { |item| item.name == name }
      end

      # Public: creates a Hash of the representation of the in-memory data
      # structure. This percolates down to Items by calling to_hash on the List,
      # which in tern calls to_hash on individual Items.
      #
      # Returns a Hash of the entire data set.
      def to_hash
        { :lists => lists.collect(&:to_hash) }
      end

    end
  end
end
