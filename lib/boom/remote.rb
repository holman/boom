module Boom
  module Remote
    def allowed_storage_types
      [Boom::Storage::Gist, Boom::Storage::Mongodb, Boom::Storage::Redis]
    end

    def allowed? storage
      return true if Boom.local?

      allowed_storage_types.include? storage.class
    end

    extend self
  end
end
