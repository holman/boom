unless Symbol.method_defined?(:to_proc)
  class Symbol
    def to_proc
      Proc.new { |obj, *args| obj.send(self, *args) }
    end
  end
end
