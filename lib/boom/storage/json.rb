# coding: utf-8
#
# JSON is the default storage option for boom. It writes a json file to
# ~/.boom. Pretty neat, huh?
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

      # Takes care of bootstrapping the JSON file, both in terms of creating the
      # file and in terms of creating a skeleton JSON schema.
      #
      # Return true if successfully saved.
      def bootstrap
        return if File.exist?(json_file)
        FileUtils.touch json_file
        File.open(json_file, 'w') {|f| f.write(to_json) }
        save!
      end

      # Take a JSON representation of data and explode it out into the consituent
      # Lists and Items for the given Storage instance.
      #
      # Returns nothing.
      def setup
        storage = Yajl::Parser.new.parse(File.new(json_file, 'r'))
      
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

      # Public: persists your in-memory objects to disk in JSON format.
      #
      # lists_json - list in JSON format
      #
      # Returns true if successful, false if unsuccessful.
      def save
        File.open(json_file, 'w') {|f| f.write(to_json) }
      end

      # Public: the JSON representation of the current List and Item assortment
      # attached to the Storage instance.
      #
      # Returns a String JSON representation of its Lists and their Items.
      def to_json
        Yajl::Encoder.encode(to_hash, :pretty => true)
      end

    end
  end
end
