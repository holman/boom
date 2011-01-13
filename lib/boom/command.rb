# coding: utf-8

# Command is the main point of entry for boom commands; shell arguments are
# passd through to Command, which then filters and parses through indivdual
# commands and reroutes them to constituent object classes.
#
# Command also keeps track of one connection to Storage, which is how new data
# changes are persisted to disk. It takes care of any data changes by calling
# Boom::Command#save!.
#
module Boom
  class Command
    class << self

      # Public: accesses the in-memory JSON representation.
      #
      # Returns a Storage instance.
      def storage
        Boom.storage
      end

      # Public: executes a command.
      #
      # args    - The actual commands to operate on. Can be as few as zero
      #           arguments or as many as three.
      def execute(*args)
        command = args.shift
        major   = args.shift
        minor   = args.empty? ? nil : args.join(' ')

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

      # Public: prints the detailed view of all your Lists and all their
      # Items.
      #
      # Returns nothing.
      def all
        storage.lists.each do |list|
          output "  #{list.name}"
          list.items.each do |item|
            output "    #{item.short_name}:#{item.spacer} #{item.value}"
          end
        end
      end

      # Public: allows main access to most commands.
      #
      # Returns output based on method calls.
      def delegate(command, major, minor)
        return all  if command == 'all'
        return edit if command == 'edit'
        return help if command == 'help'
        return help if command != "-o" && (command[0] == 45 || command[0] == '-') # any - dash options are pleas for help, except -o

        # prepare for -o switch
        method = :copy
        method, command, major = :open, major, minor if command == "-o"
          
        # if we're operating on a List        
        if storage.list_exists?(command)
          return delete_list(command) if major == 'delete'
          return detail_list(command) unless major
          unless minor == 'delete'
            return add_item(command,major,minor) if minor
            return search_list_for_item(command, major, method)
          end
        end

        return search_items(command, method) if storage.item_exists?(command)

        if minor == 'delete' and storage.item_exists?(major)
          return delete_item(command, major)
        end

        return create_list(command)
      end

      # Public: prints all Items over a List.
      #
      # name - the List object to iterate over
      #
      # Returns nothing.
      def detail_list(name)
        list = List.find(name)
        list.items.sort{ |x,y| x.name <=> y.name }.each do |item|
          output "    #{item.short_name}:#{item.spacer} #{item.value}"
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
      def create_list(name)
        lists = (storage.lists << List.new(name))
        storage.lists = lists
        output "Boom! Created a new list called \"#{name}\"."
        save!
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
      def delete_list(name)
        output "You sure you want to delete everything in \"#{name}\"? (y/n):"
        if $stdin.gets.chomp == 'y'
          List.delete(name)
          output "Boom! Deleted all your #{name}."
          save!
        else
          output "Just kidding then."
        end
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
        list = List.find(list)
        list.add_item(Item.new(name,value))
        output "Boom! \"#{name}\" in \"#{list.name}\" is \"#{value}\". Got it."
        save!
      end

      # Public: remove a named Item.
      #
      # list_name - the String name of the List.
      # name      - the String name of the Item.
      #
      # Example
      #
      #   Commands.delete_item("a-list-name", "an-item-name")
      #
      # Returns nothing.
      def delete_item(list_name,name)
        list = List.find(list_name)
        list.delete_item(name)
        output "Boom! \"#{name}\" is gone forever."
        save!
      end

      # Public: search for an Item in all lists by name. Drops the 
      # corresponding entry into your clipboard.
      #
      # name - the String term to search for in all Item names
      # method - the Symbol method later called on Platform with item
      #
      # Returns the matching Item.
      def search_items(name, method = :copy)
        item = storage.items.detect do |item|
          item.name == name
        end

        output Platform.send(method, item)
      end

      # Public: search for an Item in a particular list by name. Drops the 
      # corresponding entry into your clipboard if found.
      #
      # list_name - the String name of the List in which to scope the search
      # item_name - the String term to search for in all Item names
      #
      # Returns the matching Item if found.
      def search_list_for_item(list_name, item_name, method = :copy)
        list = List.find(list_name)
        item = list.find_item(item_name)

        if item
          output Platform.send(method, item)
        else
          output "\"#{item_name}\" not found in \"#{list_name}\""
        end
      end

      # Public: save in-memory data to disk.
      #
      # Returns whether or not data was saved.
      def save!
        storage.save!
      end

      # Public: launches JSON file in an editor for you to edit manually. Uses
      # the $EDITOR environment variable for editing.
      #
      # Returns nothing.
      def edit
        system "`echo $EDITOR` #{storage.json_file} &"
        output "Boom! Make your edits, and do be sure to save."
      end

      # Public: prints all the commands of boom.
      #
      # Returns nothing.
      def help
        text = %{
          - boom: help ---------------------------------------------------

          boom                          display high-level overview
          boom all                      show all items in all lists
          boom edit                     edit the boom JSON file in $EDITOR
          boom help                     this help text
          
          boom <list>                   create a new list
          boom <list>                   show items for a list
          boom <list> delete            deletes a list

          boom <list> <name> <value>    create a new list item
          boom <name>                   copy item's value to clipboard
          boom <list> <name>            copy item's value to clipboard
          boom <list> <name> delete     deletes an item

          all other documentation is located at:
            https://github.com/holman/boom
        }.gsub(/^ {8}/, '') # strip the first eight spaces of every line

        output text
      end

    end
  end
end
