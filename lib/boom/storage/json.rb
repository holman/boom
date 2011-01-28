# coding: utf-8

# Storage is the middleman between changes the client makes in-memory and how
# it's actually persisted to disk (and vice-versa). There are also a few
# convenience methods to run searches and operations on the in-memory hash.
#
module Boom
  module Storage
    class JSON < Base
    
      JSON_FILE = "#{ENV['HOME']}/.boom"

      # Public: the path to the JSON file used by boom.
      #
      # Returns the String path of boom's JSON representation.
      def json_file
        JSON_FILE
      end

      # Public: initializes a Storage instance by loading in your persisted data.
      #
      # Returns the Storage instance.
      def initialize
        @lists = []
        explode_json(json_file)
      end

      # Public: the in-memory collection of all Lists attached to this Storage
      # instance.
      #
      # lists - an Array of individual List items
      #
      # Returns nothing.
      attr_writer :lists

      # Public: get the data from storage
      #
      # Returns the list
      def lists
        @lists
      end

      # Public: persists your in-memory objects to disk in JSON format.
      #
      # lists_json - list in JSON format
      #
      # Returns true if successful, false if unsuccessful.
      def save(lists_json)
        File.open(json_file, 'w') {|f| f.write(lists_json) }
      end

    # INTERNAL METHODS ##########################################################

      # Take a JSON representation of data and explode it out into the consituent
      # Lists and Items for the given Storage instance.
      #
      # Returns nothing.
      def explode_json(json)
        bootstrap_json unless File.exist?(json)

        storage = Yajl::Parser.new.parse(File.new(json, 'r'))
      
        storage['lists'].each do |lists|
          lists.each do |list_name, items|
            @lists << list = List.new(list_name)

            items.each do |item|
              item.each do |name,value|
                list.add_item(Item.new(name,value))
              end
            end
          end
        end
      end

      # Takes care of bootstrapping the JSON file, both in terms of creating the
      # file and in terms of creating a skeleton JSON schema.
      #
      # Return true if successfully saved.
      def bootstrap_json
        FileUtils.touch json_file
        File.open(json_file, 'w') {|f| f.write(to_json) }
        save!
      end

    end
  end
end
