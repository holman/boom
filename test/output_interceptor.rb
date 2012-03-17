module Boom
  module Output

    def capture_output
      @output = ''
    end

    def captured_output
      @output
    end

    def output(s)
      @output << s
    end

    extend self
  end
end

# Intercept STDOUT and collect it
class Boom::Command


  def self.save!
    # no-op
  end

end
