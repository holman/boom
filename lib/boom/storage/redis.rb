# coding: utf-8
#
# Sup, Redis.
#
begin
  require 'digest'
  require 'redis'
  require 'uri'
rescue LoadError
end

module Boom
  module Storage
    class Redis < Base

      def redis
        uri = URI.parse(Boom.config.attributes['uri'] || '')

        @redis ||= ::Redis.new :host     => (uri.host     || Boom.config.attributes["redis"]["host"]),
                               :port     => (uri.port     || Boom.config.attributes["redis"]["port"]),
                               :user     => (uri.user     || Boom.config.attributes["redis"]["user"]),
                               :password => (uri.password || Boom.config.attributes["redis"]["password"])
      rescue NameError => e
        puts "You don't have Redis installed yet:\n  gem install redis"
        exit
      end

      def bootstrap
      end

      def populate
        lists = redis.smembers("boom:lists") || []

        lists.each do |sha|
          list_name  = redis.get("boom:lists:#{sha}:name")
          @lists << list = List.new(list_name)

          shas = redis.lrange("boom:lists:#{sha}:items",0,-1) || []

          shas.each do |item_sha|
            name  = redis.get "boom:items:#{item_sha}:name"
            value = redis.get "boom:items:#{item_sha}:value"
            list.add_item(Item.new(name, value))
          end
        end
      end

      def clear
        redis.del "boom:lists"
        redis.del "boom:items"
      end

      def save
        clear

        lists.each do |list|
          list_sha = Digest::SHA1.hexdigest(list.name)
          redis.set   "boom:lists:#{list_sha}:name", list.name
          redis.sadd  "boom:lists", list_sha

          list.items.each do |item|
            item_sha = Digest::SHA1.hexdigest(item.name)
            redis.rpush "boom:lists:#{list_sha}:items", item_sha
            redis.set   "boom:items:#{item_sha}:name", item.name
            redis.set   "boom:items:#{item_sha}:value", item.value
          end
        end
      end

    end
  end
end
