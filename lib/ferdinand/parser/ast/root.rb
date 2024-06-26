module Ferdinand::Parser::Ast
  class Root < Node
    def initialize(node = nil)
      self << node if !node.nil?
    end

    def ==(other)
      return false if self.class != other.class

      children == other.children
    end
  end
end
