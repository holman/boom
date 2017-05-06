#
# Storage is the interface between multiple Backends. You can use Storage
# directly without having to worry about which Backend is in use.
#
module Boom
  class Storage
    JSON_FILE = "#{ENV['HOME']}/.boom"

    # Public: the path to the Json file used by boom.
    #
    # Returns the String path of boom's Json representation.
    def json_file
      ENV['BOOMFILE'] || JSON_FILE
    end

    # Public: initializes a Storage instance by loading in your persisted data from adapter.
    #
    # Returns the Storage instance.
    def initialize
      @lists = []
      bootstrap
      populate
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
    # which in turn calls to_hash on individual Items.
    #
    # Returns a Hash of the entire data set.
    def to_hash
      { :lists => lists.collect(&:to_hash) }
    end

    # Takes care of bootstrapping the Json file, both in terms of creating the
    # file and in terms of creating a skeleton Json schema.
    #
    # Return true if successfully saved.
    def bootstrap
      return if File.exist?(json_file) and !File.zero?(json_file)
      FileUtils.touch json_file
      File.open(json_file, 'w') {|f| f.write(to_json) }
      save
    end

    # Take a JSON representation of data and explode it out into the constituent
    # Lists and Items for the given Storage instance.
    #
    # Returns nothing.
    def populate
      file = File.new(json_file, 'r')
      begin
        storage = Yajl::Parser.parse(file)
      rescue Yajl::ParseError
        puts "Looks like your boom file (#{json_file}) is corrupted."
        exit
      end

      if storage.nil? or storage.empty?
        puts "Looks like your boom file (#{json_file}) is empty."
        exit
      end

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
      Yajl::Encoder.encode(to_hash, :pretty => true)
    end
  end
end
