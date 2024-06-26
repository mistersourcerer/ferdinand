module Ferdinand::Parser::Ast
  class Part < Node
    def initialize(name, pins: {})
      super(name)
      @pins = Node.new(:pins)
      pins.each_pair { |k, v| pin(k, v) }
    end

    def pin(name, pin)
      @pins << Pin.new(name).tap { |n| n << Ast.Pin(pin) }
    end

    def ==(other)
      return false if self.class != other.class

      name == other.name && pins == other.pins
    end

    def pretty_print(q)
      super.child(@pins)
    end

    protected

    attr_reader :pins
  end
end
