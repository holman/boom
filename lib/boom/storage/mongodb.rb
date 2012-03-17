# coding: utf-8

# Storage adapter that saves data from boom to MongoDB instead of JSON file.
begin
  require 'mongo'
rescue LoadError
end

module Boom
  module Storage
    class Mongodb < Base

      def self.sample_config
        %(
          {"backend": "mongodb",
            "mongodb": {
              "port": "",
              "host": ""
              "database": ""
              "username": ""
              "password": ""
            }
          })
      end

      # Public: Initialize MongoDB connection and check dep.
      #
      # Returns Mongo connection
      def mongo
        @mongo ||= ::Mongo::Connection.new(
          Boom.config.attributes["mongodb"]["host"],
          Boom.config.attributes["mongodb"]["port"]
        ).db(Boom.config.attributes["mongodb"]["database"])

        @mongo.authenticate(
          Boom.config.attributes['mongodb']['username'],
          Boom.config.attributes['mongodb']['password']
        )

        # Return connection
        @mongo
      rescue  Exception => exception
        handle exception, "You don't have the Mongo gem installed yet:\n  gem install mongo"
      end

      # Public: The MongoDB collection
      #
      # Returns the MongoDB collection
      def collection
        @collection ||= mongo.collection(Boom.config.attributes["mongodb"]["collection"])
      end

      # Public: Bootstrap
      #
      # Returns
      def bootstrap
        collection.insert("boom" => '{"lists": [{}]}') if collection.find_one.nil?
      end

      # Public: Populates the memory list from MongoDB
      #
      # Returns nothing
      def populate
        storage = MultiJson.decode(collection.find_one['boom']) || []

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

      # Public: Save to MongoDB
      #
      # Returns Mongo ID
      def save
        doc = collection.find_one()
        collection.update({"_id" => doc["_id"]}, {'boom' => to_json})
      end

      # Public: Convert to JSON
      #
      # Returns
      def to_json
       MultiJson.encode(to_hash)
      end

    end
  end
end
