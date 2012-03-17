# coding: utf-8
#
# Json is the default storage option for boom. It writes a Json file to
# ~/.boom. Pretty neat, huh?
#
module Boom
  module Storage
    class Json < Base

      JSON_FILE = "#{ENV['HOME']}/.boom"

      # Public: the path to the Json file used by boom.
      #
      # Returns the String path of boom's Json representation.
      def json_file
        JSON_FILE
      end

      # Takes care of bootstrapping the Json file, both in terms of creating the
      # file and in terms of creating a skeleton Json schema.
      #
      # Return true if successfully saved.
      def bootstrap
        return if File.exist?(json_file)
        FileUtils.touch json_file
        File.open(json_file, 'w') {|f| f.write(to_json) }
        save
      end

      # Take a Json representation of data and explode it out into the consituent
      # Lists and Items for the given Storage instance.
      #
      # Returns nothing.
      def populate
        storage = MultiJson.decode(File.new(json_file, 'r').read)

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

      # Public: persists your in-memory objects to disk in Json format.
      #
      # lists_Json - list in Json format
      #
      # Returns true if successful, false if unsuccessful.
      def save
        File.open(json_file, 'w') {|f| f.write(to_json) }
      end

      # Public: the Json representation of the current List and Item assortment
      # attached to the Storage instance.
      #
      # Returns a String Json representation of its Lists and their Items.
      def to_json
        MultiJson.encode(to_hash)
      end

    end
  end
end
