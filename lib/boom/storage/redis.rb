# coding: utf-8
#
# Sup, Redis.
#
begin
  require 'digest'
  require 'redis'
rescue LoadError
end

module Boom
  module Storage
    class Redis < Base
      include Boom::Color
      include Boom::Output

      def redis
        @redis ||= ::Redis.new :host => Boom.config.attributes["redis"]["host"],
          :port => Boom.config.attributes["redis"]["port"]
      rescue  Exception => exception
        handle exception
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


      private

      def handle error
        case error
        when NoMethodError
          output cyan config_text
        when NameError
          output red("You don't have Redis installed yet:\n  gem install redis")
        end

        exit
      end

      def config_text
        %(#{red "Is your redis config correct? You said:"}

        #{File.read Boom.config.file}

        #{cyan "Our survey says:"}

        {
          "backend": "redis",
          "redis": {
            "port": "6379",
            "host": "localhost"
          }
        }

        #{yellow "Go edit "} #{Boom.config.file +  yellow(" and make it all better") }
        ).gsub(/^ {8}/, '') # strip the first eight spaces of every line
      end

    end
  end

end
