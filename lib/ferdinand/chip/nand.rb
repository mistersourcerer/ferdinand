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
        out = if a == 1 && b == 1
          0
        else
          1
        end

        Output.new(out: out)
      end
    end
  end
end
