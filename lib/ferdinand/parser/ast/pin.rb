module Ferdinand::Parser::Ast
  def self.Pin(name)
    return name if name.is_a?(Pin)

    Pin.new(name)
  end

  class Pin < Node
    attr_accessor :size
    attr_reader :name

    def initialize(name, size: 1)
      @size = size
      @name = String(name)
    end

    def ==(other)
      return false if self.class != other.class

      name == other.name
    end
  end
end
