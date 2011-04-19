# coding: utf-8

# Keychain provides methods for using Mac OS X's Keychain as a storage option.
# It saves lists as Keychain files in ~/Library/Keychains with the filename
# format being: "Boom.list.mylist.keychain"
#
module Boom
  module Storage
    class Keychain < Base

      KEYCHAIN_FORMAT = %r{Boom\.list\.(.+)\.keychain}

      # Opens Keychain app when json_file is called during `boom edit`
      #
      # Returns nothing
      def open_keychain_app
        `open /Applications/Utilities/'Keychain Access.app' &`
      end

      alias_method :json_file, :open_keychain_app

      # Boostraps Keychain by asking if you're using Mac OS X which is a prereq
      #
      # Returns true on a Mac
      def bootstrap
        raise RuntimeError unless Boom::Platform.darwin?
        true
      rescue
        puts(e 'No Keychain utility to access, maybe try another storage option?')
        false
      end

      # Populate the in-memory store with all the lists and items from Keychain
      #
      # Returns Array of keychain names, i.e. ["Boom.list.mylist.keychain"]
      def populate
        stored_keychain_lists.each do |keychain|
          @lists << list = List.new(keychain.scan(KEYCHAIN_FORMAT).flatten.first)
          extract_keychain_items(keychain).each do |name|
            list.add_item(Item.new(name, extract_keychain_value(name, keychain)))
          end
        end
      end

      # Saves the data from memory to the correct Keychain
      #
      # Returns nothing
      def save
        @lists.each do |list|
          keychain_name = list_to_filename(list.name)
          create_keychain_list(keychain_name) unless stored_keychain_lists.include?(keychain_name)
          unless list.items.empty?
            list.items.each do |item|
              store_item(item, keychain_name)
            end
          end
          delete_unwanted_items(list)
        end
        delete_unwanted_lists
      rescue RuntimeError
        puts(e "Couldn't save to your keychain, check Console.app or above for relevant messages")
      end


      private

      # Returns an Array of keychains stored in ~/Library/Keychains:
      # => ["Boom.list.mylist.keychain"]
      def stored_keychain_lists
        @stored_keychain_lists ||= `security -q list-keychains |grep Boom.list` \
          .split(/[\/\n\"]/).select {|kc| kc =~ KEYCHAIN_FORMAT}
      end

      # Create the keychain list "Boom.list.mylist.keychain" in ~/Library/Keychains
      def create_keychain_list(keychain_name)
        `security -q create-keychain #{keychain_name}`
      end

      # Saves the individual item's value to the right list/keychain
      def store_item(item, keychain_name)
        `security 2>/dev/null -q add-generic-password -a '#{item.name}' -s '#{item.name}' -w '#{item.value}' #{keychain_name}`
      end

      # Retrieves the value of a particular item in a list
      def extract_keychain_value(item_name, keychain)
        `security 2>&1 >/dev/null find-generic-password -ga '#{item_name}' #{keychain}`.chomp.split('"').last
      end

      # Gets all items in a particular list
      def extract_keychain_items(keychain_name)
        @stored_items ||= {}
        @stored_items[keychain_name] ||= `security dump-keychain -a #{keychain_name} |grep acct` \
          .split(/\s|\\n|\\"|acct|<blob>=|\"/).reject {|f| f.empty?}
      end

      # Converts list name to the corresponding keychain filename format based
      # on the KEYCHAIN_FORMAT
      def list_to_filename(list_name)
        KEYCHAIN_FORMAT.source.gsub(/\(\.\+\)/, list_name).gsub('\\','')
      end

      # Delete's a keychain file
      def delete_list(keychain_filename)
        `security delete-keychain #{keychain_filename}`
      end

      # Delete's all keychain files you don't want anymore
      def delete_unwanted_lists
        (stored_keychain_lists - @lists.map {|list| list_to_filename(list.name)}).each do |filename|
          delete_list(filename)
        end
      end

      # Removes unwanted items in a list
      # security util doesn't have a delete password option so we'll have to
      # drop it and recreate it with what is in memory
      def delete_unwanted_items(list)
        filename = list_to_filename(list.name)
        if (list.items.size < extract_keychain_items(filename).size)
          delete_list(filename)
          create_keychain_list(filename)
          list.items.each do |item|
            store_item(item, filename)
          end unless list.items.empty?
        end
      end
    end
  end
end
