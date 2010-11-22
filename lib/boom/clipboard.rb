module Boom
  class Clipboard
    class << self
      
      # Public: copies a given Item's value to the clipboard. This method is
      # designed to handle multiple platforms.
      #
      # Returns nothing.
      def copy(item)
        if RUBY_PLATFORM =~ /darwin/
          `echo '#{item.value}' | tr -d "\n" | pbcopy`
        end

        "Boom! We just copied #{item.value} to your clipboard."
      end

    end
  end
end
