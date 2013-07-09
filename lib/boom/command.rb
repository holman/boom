# coding: utf-8

# Command is the main point of entry for boom commands; shell arguments are
# passed through to Command, which then filters and parses through individual
# commands and reroutes them to constituent object classes.
#
# Command also keeps track of one connection to Storage, which is how new data
# changes are persisted to disk. It takes care of any data changes by calling
# Boom::Command#save.
#
module Boom
  class Command
    class << self
      include Boom::Color

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

      # Public: gets $stdin.
      #
      # Returns the $stdin object. This method exists to help with easy mocking
      # or overriding.
      def stdin
        $stdin
      end

      # Public: prints a tidy overview of your Lists in descending order of
      # number of Items.
      #
      # Returns nothing.
      def overview
        storage.lists.each do |list|
          output "  #{list.name} (#{list.items.size})"
        end
        s =  "You don't have anything yet! To start out, create a new list:"
        s << "\n  $ boom <list-name>"
        s << "\nAnd then add something to your list!"
        s << "\n  $ boom <list-name> <item-name> <item-value>"
        s << "\nYou can then grab your new item:"
        s << "\n  $ boom <item-name>"
        output s if storage.lists.size == 0
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
        return all               if command == 'all'
        return edit              if command == 'edit'
        return version           if command == "-v"
        return version           if command == "--version"
        return help              if command == 'help'
        return help              if command[0] == 45 || command[0] == '-' # any - dash options are pleas for help
        return echo(major,minor) if command == 'echo' || command == 'e'
        return copy(major,minor) if command == 'copy' || command == 'c'
        return open(major,minor) if command == 'open' || command == 'o'
        return random(major)     if command == 'random' || command == 'rand' || command == 'r'

        # if we're operating on a List
        if storage.list_exists?(command)
          return delete_list(command) if major == '--delete'
          return detail_list(command) unless major
          unless minor == '--delete'
            return add_item(command,major,minor) if minor
            return add_item(command,major,stdin.read) if stdin.stat.size > 0
            return search_list_for_item(command, major)
          end
        end

        if minor == '--delete' and storage.item_exists?(major)
          return delete_item(command, major)
        end

        return search_items(command) if storage.item_exists?(command) and !major

        return create_list(command, major, stdin.read) if !minor && stdin.stat.size > 0
        return create_list(command, major, minor)
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

      # Public: opens the Item.
      #
      # Returns nothing.
      def open(major, minor)
        if storage.list_exists?(major)
          list = List.find(major)
          if minor
            item = storage.items.detect { |item| item.name == minor }
            if item
              output "#{cyan("Boom!")} We just opened #{yellow(Platform.open(item))} for you."
            else
              output "Couldn't find #{yellow(minor)}."
              find_closest(minor)
            end
          else
            list.items.each { |item| Platform.open(item) }
            output "#{cyan("Boom!")} We just opened all of #{yellow(major)} for you."
          end
        else
          item = storage.items.detect { |item| item.name == major }
          if item
            output "#{cyan("Boom!")} We just opened #{yellow(Platform.open(item))} for you."
          else
            output "Couldn't find #{yellow(major)}."
            find_closest(major)
          end
        end
      end

      # Public: Opens a random item
      #
      # Returns nothing.
      def random(major)
        if major.nil?
          index = rand(storage.items.size)
          item = storage.items[index]
        elsif storage.list_exists?(major)
          list = List.find(major)
          index = rand(list.items.size)
          item = list.items[index]
        else
          output "We couldn't find that list."
        end
        open(item.name, nil) unless item.nil?
      end

      # Public: echoes only the Item's value without copying
      #
      # item_name - the String term to search for in all Item names
      #
      # Returns nothing
      def echo(major, minor)
        unless minor
          item = storage.items.detect do |item|
            item.name == major
          end
          return output "#{yellow(major)} #{red("not found")}" unless item
        else
          list = List.find(major)
          item = list.find_item(minor)
          return output "#{yellow(minor)} #{red("not found in")} #{yellow(major)}" unless item
        end
        output item.value
      end

      # Public: Copies to clipboard the Item's value without printing to screen
      #
      # Returns nothing
      def copy(major, minor)
        unless minor
          item = storage.items.detect do |item|
            item.name == major
          end
          unless item
            output "#{yellow(major)} #{red("not found")}"
            return find_closest(major)
          end
        else
          list = List.find(major)
          item = list.find_item(minor)
          unless item
            output "#{yellow(minor)} #{red("not found in")} #{yellow(major)}"
            return find_closest(minor)
          end
        end
        Platform.copy(item)
      end

      # Public: add a new List.
      #
      # name  - the String name of the List.
      # item  - the String name of the Item
      # value - the String value of Item
      #
      # Example
      #
      #   Commands.list_create("snippets")
      #   Commands.list_create("hotness", "item", "value")
      #
      # Returns the newly created List and creates an item when asked.
      def create_list(name, item = nil, value = nil)
        lists = (storage.lists << List.new(name))
        storage.lists = lists
        output "#{cyan("Boom!")} Created a new list called #{yellow(name)}."
        save
        add_item(name, item, value) unless value.nil?
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
        printf "You sure you want to delete everything in #{yellow(name)}? (y/n): "
        if $stdin.gets.chomp == 'y'
          List.delete(name)
          output "#{cyan("Boom!")} Deleted all your #{yellow(name)}."
          save
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
        output "#{cyan("Boom!")} #{yellow(name)} in #{yellow(list.name)} is #{yellow(value)}. Got it."
        save
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
        if storage.list_exists?(list_name)
          list = List.find(list_name)
          if list.delete_item(name)
            output "#{cyan("Boom!")} #{yellow(name)} is gone forever."
            save
          else
            output "#{yellow(name)} #{red("not found in")} #{yellow(list_name)}"
          end
        else
          output "We couldn't find that list."
        end
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

        output "#{cyan("Boom!")} We just copied #{yellow(Platform.copy(item))} to your clipboard."
      end

      # Public: search for an Item in a particular list by name. Drops the
      # corresponding entry into your clipboard if found.
      #
      # list_name - the String name of the List in which to scope the search
      # item_name - the String term to search for in all Item names
      #
      # Returns the matching Item if found.
      def search_list_for_item(list_name, item_name)
        list = List.find(list_name)
        item = list.find_item(item_name)

        if item
          output "#{cyan("Boom!")} We just copied #{yellow(Platform.copy(item))} to your clipboard."
        else
          output "#{yellow(item_name)} #{red("not found in")} #{yellow(list_name)}"
        end
      end

      # Public: save in-memory data to disk.
      #
      # Returns whether or not data was saved.
      def save
        storage.save
      end

      # Public: the version of boom that you're currently running.
      #
      # Returns a String identifying the version number.
      def version
        output "You're running boom #{Boom::VERSION}. Congratulations!"
      end

      # Public: launches JSON file in an editor for you to edit manually.
      #
      # Returns nothing.
      def edit
        output "#{cyan("Boom!")} #{Platform.edit(storage.json_file)}"
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
          boom <list> --delete          deletes a list

          boom <list> <name> <value>    create a new list item
          boom <name>                   copy item's value to clipboard
          boom <list> <name>            copy item's value to clipboard
          boom open <name>              open item's url in browser
          boom open <list> <name>       open all item's url in browser for a list
          boom random                   open a random item's url in browser
          boom random <list>            open a random item's url for a list in browser
          boom echo <name>              echo the item's value without copying
          boom echo <list> <name>       echo the item's value without copying
          boom copy <name>              copy the item's value without echo
          boom copy <list> <name>       copy the item's value without echo
          boom <list> <name> --delete   deletes an item

          all other documentation is located at:
            https://github.com/holman/boom
        }.gsub(/^ {8}/, '') # strip the first eight spaces of every line

        output text
      end

      # Public: output a "Did you mean this..."
      # when the user search for a non-existing item
      #
      # search - item the user typped
      #
      # Returns nothing.
      def find_closest(search)
        results = Array.new
        items = storage.items.each do |item|
          if Levenshtein.distance(search, item.name) < 7
            results.push(item.name)
          end
        end
        if results.count == 1
          output 'Did you mean this?'
          output "    #{results[0]}"
        elsif results.count > 1
          output 'Did you mean one of these?'
          results.each do |suggestion|
            output "    #{suggestion}"
          end
        end
      end

    end
  end
end
