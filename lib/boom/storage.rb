# coding: utf-8

#
# Storage is the interface between multiple Backends. You can use Storage
# directly without having to worry about which Backend is in use.
#
module Boom
  module Storage
    
    def self.backend=(backend)
      backend = backend.capitalize
      Boom::Storage.const_get(backend)
      Boom.config.attributes['backend'] = backend.downcase
      Boom.config.save
    end

    def self.backend
      Boom::Storage.const_get(Boom.config.attributes['backend'].capitalize).new
    end

  end
end
