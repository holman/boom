require 'boom'

unless Capistrano::Configuration.respond_to?(:instance)
  abort "boom/capistrano requires Capistrano >= 2."
end

Capistrano::Configuration.instance(true).load do

  def include_boom(list_name)
    list = Boom::List.find(list_name)
    if list
      list.to_hash.flatten[1].each do |item|
        item.each do |key, value|
          default_environment["#{list_name}_#{key}".upcase] = value.to_s
        end
      end
    end
  end

end

# E.g, to set environment variables from a boom list.
#
#   require 'boom/capistrano'
#   include_boom app_name
#