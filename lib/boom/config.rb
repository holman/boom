# coding: utf-8

#
# Config manages all the config information for boom and its backends. It's a
# simple JSON Hash that gets persisted to `~/.boom` on-disk. You may access it
# as a Hash:
#
#     config.attributes = { :backend => "JSON" }
#     config.attributes[:backend]
#     # => "json"
#
#     config.attributes[:backend] = "Redis"
#     config.attributes[:backend]
#     # => "redis"
#
module Boom
  class Config

    # The main config file for boom
    FILE        = "#{ENV['HOME']}/.boom.conf"
    REMOTE_FILE = FILE.gsub(/\.conf$/, ".remote.conf")

    #if set to true then we will use a different config file for storage
    #engine
    attr_accessor :remote

    # Public: The attributes Hash for configuration options. The attributes
    # needed are dictated by each backend, but the `backend` option must be
    # present.
    attr_reader :attributes


    # Public: an alias for accessing Boom.config.attributes[key]
    # like Boom.config[key] instead
    #
    # Returns the value in the attributes hash
    def [] key
      attributes[key]
    end

    # Public: creates a new instance of Config.
    #
    # This will load the attributes from boom's config file, or bootstrap it
    # if this is a new install. Bootstrapping defaults to the JSON backend.
    #
    # Returns nothing.
    def initialize remote=false
      @remote = remote
      bootstrap unless File.exist?(file)
      load_attributes
    end

    # Public: accessor for the configuration file.
    #
    # Returns the String file path.
    def file
      remote ? REMOTE_FILE : FILE
    end

    # Public: saves an empty, barebones hash to @attributes for the purpose of
    # new user setup.
    #
    # Returns whether the attributes were saved.
    def bootstrap
      @attributes = {
        :backend => 'json'
      }
      save
    end

    # Public: assigns a hash to the configuration attributes object. The
    # contents of the attributes hash depends on what the backend needs. A
    # `backend` key MUST be present, however.
    #
    # attrs - the Hash representation of attributes to persist to disk.
    #
    # Examples
    #
    #     config.attributes = {"backend" => "json"}
    #
    # Returns whether the attributes were saved.
    def attributes=(attrs)
      @attributes = attrs
      save
    end

    # Public: loads and parses the JSON tree from disk into memory and stores
    # it in the attributes Hash.
    #
    # Returns nothing.
    def load_attributes
      @attributes = MultiJson.decode(File.new(file, 'r').read)
    end

    # Public: writes the in-memory JSON Hash to disk.
    #
    # Returns nothing.
    def save
      json = MultiJson.encode(attributes)
      File.open(file, 'w') {|f| f.write(json) }
    end

    def invalid_message
      %(#{red "Is your config correct? You said:"}

      #{File.read Boom.config.file}

      #{cyan "Our survey says:"}

      #{self.class.sample_config}

      #{yellow "Go edit "} #{Boom.config.file +  yellow(" and make it all better") }
      ).gsub(/^ {8}/, '') # strip the first eight spaces of every line
    end


  end
end
