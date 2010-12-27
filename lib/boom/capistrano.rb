require 'boom'

unless Capistrano::Configuration.respond_to?(:instance)
  abort "boom/capistrano requires Capistrano >= 2."
end

Capistrano::Configuration.instance(true).load do

  def boom(list_name)
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
#   ## from your local shell
#
#   boom mailapp
#   boom mailapp postmark_api_key ca8b84aab0c88ce7a459650f6a17828199ab
#   boom mailapp postmark_from_address no-replies@app_name.co
#                        
#   ## in config/deploy.rb
# 
#   require 'boom/capistrano'
#   boom mailapp
#                    
#   ## in app/mailer.rb
#                
#   Postmark.api_key = ENV['MAILAPP_POSTMARK_API_KEY']
#   ...
#   message.from = ENV['MAILAPP_POSTMARK_FROM_ADDRESS']
#    