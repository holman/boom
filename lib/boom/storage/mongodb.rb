# coding: utf-8

# Storage adapter that saves data from boom to MongoDB instead of JSON file.
#
# This was grabbed from antonlindstrom's fork, but he wrote it before the 0.1.0
# changes to boom. It would need to be updated to use Boom::Config and to
# inherit methods from Boom::Storage::Base. Until then, this is chillin' here
# until it gets fixed.

module Boom
  module Storage
    class MongoDB
      
      MONGO_CFG = "#{ENV['HOME']}/.boomdb.conf"

      # Public: the path to the JSON Mongo config file, userdata.
      #
      # Returns the String path of boom's MongoDB userdata
      def mongo_cfg
        MONGO_CFG
      end

      # Public: initializes a Storage instance by loading in your persisted data.
      #
      # Returns the Storage instance.
      def initialize
        require 'mongo'
        
        @lists = []
        @mongo_coll = nil
        mongo_initialize(mongo_cfg) # Initialize the MongoDB and set data in memory
        collect
      end

      # Public: return the list from mongodb
      #
      # Returns list
      def lists
        @lists
      end

      # Public: Save to MongoDB
      #
      # lists_json - the list to be saved in JSON format
      #
      # Returns whatever mongo returns.
      def save(lists_json)
        doc = @mongo_coll.find_one()
        @mongo_coll.update({"_id" => doc["_id"]}, {'boom' => lists_json})
      end

    # INTERNAL METHODS ##########################################################

      # Take a JSON representation of data and explode it out into the consituent
      # Lists and Items for the given Storage instance.
      #
      # Returns nothing.
      def collect

        s = @mongo_coll.find_one['boom']
        storage = Yajl::Parser.new.parse(s)

        return if storage['lists'].nil?

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

    ##### MONGODB ######

      # Initialize MongoDB and set data in memory
      #
      # config_file - The MongoDB config_file path defined
      #
      # Returns database obj.
      def mongo_initialize(config_file)
        bootstrap_config(config_file) unless File.exists?(config_file)
        config = parse_mongo_cfg(config_file)

        db = Mongo::Connection.new(config['host'], config['port']).db(config['database'])
        auth = db.authenticate(config['username'], config['password'])

        # Get collection collection;
        @mongo_coll = db.collection(config['collection'])

        @mongo_coll.insert("boom" => '{"lists": [{}]}') if @mongo_coll.find_one.nil?

        return @mongo_coll
      end

      # Parse Mongo JSON Config
      #
      # config_file - The MongoDB config_file path defined
      #
      # Returns a hash of Mongo Userdata
      def parse_mongo_cfg(config_file)

        mongod = Hash.new
        config = Yajl::Parser.new.parse(File.open(config_file, 'r'))

        config.each_pair do |type, data|
          mongod[type] = data
        end
        return mongod
      end

      # Run a default config
      #
      # config_file - The MongoDB config_file path defined
      #
      # Returns File obj.
      def bootstrap_config(config_file)
        config = Hash.new

        config['host'] = 'localhost'
        config['port'] = '27017'
        config['database'] = 'boom'
        config['username'] = 'boom'
        config['password'] = 's3cr3t'
        config['collection'] = 'boom'

        # Write to CFG
        json_cfg =  Yajl::Encoder.encode(config, :pretty => true)
        File.open(config_file, 'w') {|f| f.write(json_cfg) }
      end


    end
  end
end
