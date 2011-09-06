# coding: utf-8
#
# Gist backend for Boom.
#
# Your .boom.conf file should look like this:
#
#   {
#     "backend": "gist",
#     "gist": {
#       "username": "your_github_username",
#       "password": "your_github_password"
#     }
#   }
#
# There are two optional keys which can be under "gist":
#
#   gist_id - The ID of an existing Gist to use. If not
#     present, a Gist will be created the first time
#     Boom is run and will be persisted to the config.
#   public - Makes the Gist public. An absent value or
#     any value other than boolean true will make
#     the Gist private.
#

module Boom
  module Storage
    class Gist < Base

      def bootstrap
        begin
          require "httparty"
          require "boom/storage/gist/json_parser"

          self.class.send(:include, HTTParty)
          self.class.parser JsonParser
          self.class.base_uri "https://api.github.com"
        rescue LoadError
          puts "The Gist backend requires HTTParty: gem install httparty"
          exit
        end

        unless Boom.config.attributes["gist"]
          puts 'A "gist" data structure must be defined in ~/.boom.conf'
          exit
        end

        set_up_auth
        find_or_create_gist
      end

      def populate
        @storage['lists'].each do |lists|
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

      def save
        self.class.post("/gists/#{@gist_id}", request_params)
      end

      private

      def set_up_auth
        username, password = Boom.config.attributes["gist"]["username"], Boom.config.attributes["gist"]["password"]

        if username and password
          self.class.basic_auth(username, password)
        else
          puts "GitHub username and password must be defined in ~/.boom.conf"
          exit
        end
      end

      def find_or_create_gist
        @gist_id = Boom.config.attributes["gist"]["gist_id"]
        @public = Boom.config.attributes["gist"]["public"] == true

        if @gist_id.nil? or @gist_id.empty?
          response = self.class.post("/gists", request_params)
        else
          response = self.class.get("/gists/#{@gist_id}", request_params)
        end

        @storage = MultiJson.decode(response["files"]["boom.json"]["content"]) if response["files"] and response["files"]["boom.json"]

        unless @storage
          puts "Boom data could not be obtained"
          exit
        end

        unless @gist_id
          Boom.config.attributes["gist"]["gist_id"] = @gist_id = response["id"]
          Boom.config.save
        end
      end

      def request_params
        {
          :body => MultiJson.encode({
            :description => "boom!",
            :public => @public,
            :files => { "boom.json" => { :content => MultiJson.encode(to_hash) } }
          })
        }
      end
    end
  end
end
