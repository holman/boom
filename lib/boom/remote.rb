module Boom
  module Remote
    include Output
    include Color

    def allowed_storage_types
      [Boom::Storage::Gist, Boom::Storage::Mongodb, Boom::Storage::Redis]
    end

    # Returns true if the user is using a sensible seeming storage backend
    # Params storage, the current storage instance
    # else exits with a warning if not
    def allowed? storage
      return true if Boom.local?
      return true if allowed_storage_types.include? storage.class

      output error_message storage
      false
    end

    def error_message storage
      %(
        #{red("<<----BOOOOOM!!!----->>>> ")} (as in explosion, rather than fast)
        You probably don't want to use the #{storage.class} storage whilst
        using boom in remote mode. Your config looks akin to:

        #{red File.read Boom.config.file}

        but things might be better with something a little more like:

        #{cyan Boom::Storage::Redis.sample_config}

        or

        #{cyan Boom::Storage::Mongodb.sample_config}

        Now head yourself on over to #{yellow Boom.config.file}
        and edit some goodness into it
      ).gsub(/^ {8}/, '')
    end
    extend self
  end
end
