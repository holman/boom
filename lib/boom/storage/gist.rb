# coding: utf-8
#
# Gist backend for Boom.
#
begin
  require "httparty"
rescue LoadError
  $stderr.puts "The Gist backend requires HTTParty: gem install httparty"
  exit
end

# Crack's parsing is no bueno. Use the stdlib instead.
class JsonParser < HTTParty::Parser
  def json
    ::JSON.parse(body)
  end
end

module Boom
  module Storage
    class Gist < Base
      include HTTParty
      parser JsonParser

      def bootstrap
        unless Boom.config.attributes["gist"]
          $stderr.puts "A gist key must be defined in ~/.boom.conf"
          exit
        end

        @username = Boom.config.attributes["gist"]["username"]
        @password = Boom.config.attributes["gist"]["password"]
        @gist_id = Boom.config.attributes["gist"]["gist_id"]

        unless @username and @password
          $stderr.puts "GitHub username and password must be defined in ~/.boom.conf"
          exit
        end

        params = {
          :basic_auth => {
            :username => @username,
            :password => @password
          }
        }

        if @gist_id
          response = self.class.get("https://api.github.com/gists/#{@gist_id}", params)
        else
          params.merge!({
            :body => JSON.generate({
              :description => "Data for Boom",
              :public => false,
              :files => {
                "boom.json" => {
                  "content" => '{"lists":[]}'
                }
              }
            })
          })

          response = self.class.post("https://api.github.com/gists", params)
        end

        @storage = JSON.parse(response["files"]["boom.json"]["content"]) if response["files"] and response["files"]["boom.json"]

        unless @storage
          $stderr.puts "No Boom data could be found in this Gist"
          exit
        end
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

      end
    end
  end
end
