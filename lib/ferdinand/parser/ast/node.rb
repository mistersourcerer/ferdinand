module Ferdinand::Parser::Ast
  class Node
    include Enumerable
    attr_reader :name

    def initialize(name = nil)
      @name = name
    end

    def <<(child)
      if !child.is_a?(Node)
        raise TypeError.new("child[#{child.class}] is not a Node")
      end
      children << child

      self
    end

    def ==(other)
      return false if self.class != other.class

      name == other.name && children == other.children
    end

    def each(...)
      children.each(...)
    end

    def empty?
      children.empty?
    end

    def pretty_print(q)
      NodePrinter.new(self, q).call
    end

    protected

    def children
      @children ||= []
    end
  end
end
