module Boom
  class Command
    class << self

      attr_accessor :storage

      def execute(storage,*args)
        @storage = storage

        command = args[0]
        major   = args[1]
        minor   = args[2]

        return overview unless command
        delegate(command, major, minor)
      end

      # Public: prints any given string.
      #
      # s = String output
      #
      # Prints to STDOUT and returns. This method exists to standardize output
      # and for easy mocking or overriding.
      def output(s)
        puts(s)
      end

      # Public: prints a tidy overview of your Lists in descending order of
      # number of Items.
      #
      # Returns nothing.
      def overview
        storage.lists.each do |list|
           output "  #{list.name} (#{list.items.size})"
        end
      end

      # Public: allows main access to most commands.
      #
      # Returns output based on method calls.
      def delegate(command, major, minor)

        # if we're operating on a List
        if storage.list_exists?(command)
          return list_delete(command) if major == 'delete'
          return list_detail(command) unless major
          return search_list_for_item(command, major)
        end

        if storage.item_exists?(command)
          return search_items(command)
        end

        return list_create(command)

      end

      # Public: prints all Items over a List.
      #
      # list - the List object to iterate over
      #
      # Returns nothing.
      def list_detail(list_name)
        list = storage.lists.first { |list| list.name == list_name } 
        list.items.each do |item|
          output "    #{item.name}: #{item.value}"
        end
      end

      # Public: add a new List.
      #
      # name - the String name of the List.
      #
      # Example
      #
      #   Commands.list_create("snippets")
      #
      # Returns the newly created List.
      def list_create(name)
        lists = (storage.lists << List.new(name))
        storage.lists = lists
        output "Boom! Created a new list called \"#{name}\"."
      end

      # Public: prints all Items over all Lists.
      #
      # Returns nothing.
      def list
        storage.lists.each do |list|
          puts "  #{list.name}"
          list.items.each do |item|
            puts "    #{item.name}: #{item.value}"
          end
        end
      end

      # Public: remove a named List.
      #
      # name - the String name of the List.
      #
      # Example
      #
      #   Commands.delete_list("snippets")
      #
      # Returns nothing.
      def list_delete(name)
        lists = storage.lists.reverse.reject { |list| list.name == name }
        output "You sure you want to delete everything in \"#{name}\"? (y/n):"
        if gets == 'y'
          storage.lists = lists
          output "Boom! Deleted all your #{name}."
        else
          output "Just kidding then."
        end
      end

      # Public: adds a new List or Item, depending upon context.
      #
      # list  - the String List name
      # name  - the String name of the Item (Optional)
      # value - the String value of the Item (Optional)
      #
      # Example
      #
      #   Commands.add("snippets","sig","- @holman")
      #   Commands.add("snippets")
      #
      # Returns the newly created List or Item.
      def add(list,name=nil,value=nil)
        if value
          add_item(list,name,value)
        else
          add_list(list)
        end
        storage.save!
      end

      # Public: add a new Item to a list.
      #
      # list  - the String name of the List to associate with this Item
      # name  - the String name of the Item
      # value - the String value of the Item
      #
      # Example
      #
      #   Commands.add_item("snippets","sig","- @holman")
      #
      # Returns the newly created Item.
      def add_item(list,name,value)
        list = storage.lists.find{|storage_list| storage_list.name == list}
        list.add_item(Item.new(name,value))
        puts "Boom! \"#{name}\" in \"#{list.name}\" is \"#{value}\". Got it."
      end

      # Public: deletes an Item or List, depending upon context.
      #
      # target  - either "list" or the Item name.
      # value   - the String name of the List to delete (Optional)
      #
      # Example
      #
      #   Commands.delete("list","snippets")
      #   Commands.delete("test-item")
      #
      # Returns the newly created List or Item.
      def delete(target,name=nil)
        if target == 'list'
          delete_list(name)
        else
          delete_item(target)
        end
        storage.save!
      end

      # Public: remove a named Item.
      #
      # name - the String name of the Item.
      #
      # Example
      #
      #   Commands.delete_item("an-item-name")
      #
      # Returns nothing.
      def delete_item(name)
        storage.lists = storage.lists.each do |list|
          list.items.reject! { |item| item.name == name }
        end
        puts "Boom! \"#{name}\" is gone forever."
      end

      # Public: search for an Item in all lists by name. Drops the 
      # corresponding entry into your clipboard.
      #
      # name - the String term to search for in all Item names
      #
      # Returns the matching Item.
      def search_items(name)
        item = storage.items.detect do |item|
          item.name == name
        end

        output Clipboard.copy(item)
      end

      # Public: search for an Item in a particular list by name. Drops the 
      # corresponding entry into your clipboard.
      #
      # list_name - the String name of the List in which to scope the search
      # item_name - the String term to search for in all Item names
      #
      # Returns the matching Item.
      def search_list_for_item(list_name, item_name)
        list = storage.lists.first { |list| list.name == list_name }
        item = list.items.first { |item| item.name == item_name }

        output Clipboard.copy(item)
      end

    end
  end
end
