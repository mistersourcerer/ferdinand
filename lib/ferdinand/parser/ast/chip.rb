module Ferdinand::Parser::Ast
  class Chip < Node
    attr_reader :in, :out, :parts

    def initialize(name, &block)
      super(name)
      @in = Node.new(:input)
      @out = Node.new(:output)
      @parts = Node.new(:parts)

      instance_eval(&block) if block
    end

    def input(*pins)
      add_pins pins, to: @in
    end

    def output(*pins)
      add_pins pins, to: @out
    end

    def part(part)
      if !part.is_a?(Part)
        raise ArgumentError.new("#{part.class} expected to be a Part")
      end
      @parts << part
    end

    def ==(other)
      return false if self.class != other.class

      name == other.name &&
        self.in == other.in &&
        out == other.out &&
        parts == other.parts
    end

    def pretty_print(q)
      p = super
      q.group do
        [@in, @out, @parts].each { |n| p.child(n) }
      end
    end

    private

    def add_pins(pins, to:)
      pins.each { |pin| to << pin }
    end
  end
end
