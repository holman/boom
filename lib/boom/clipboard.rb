# Clipboard is a centralized point to shell out to each individual platform's
# clipboard, pasteboard, or whatever they decide to call it.
#
module Boom
  class Clipboard
    class << self
      
      # Public: copies a given Item's value to the clipboard. This method is
      # designed to handle multiple platforms.
      #
      # Returns nothing.
      def copy(item)
        copy_command = 
          if RUBY_PLATFORM =~ /darwin/
            "pbcopy"
          else
            "xclip -selection clipboard"
          end

        `echo '#{item.value}' | tr -d "\n" | #{copy_command}`

        "Boom! We just copied #{item.value} to your clipboard."
      end

    end
  end
end
