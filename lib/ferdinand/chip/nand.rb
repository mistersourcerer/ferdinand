module Ferdinand
  module Chip
    class Nand
      class Output
        attr_reader :out

        def initialize(out:)
          @out = out
        end
      end

      def call(a:, b:)
        out = (a == 1 && b == 1) ? 0 : 1

        Output.new(out: out)
      end

      def pretty_print(q)
        @_name ||= self.class.name.split("::").last
        q.text "<chip> "
        q.text @_name
      end
    end
  end
end
