class Ferdinand::Ast::Node
  include Enumerable
  attr_accessor :name

  def initialize(name = nil)
    @name = name
  end

  def <<(child)
    # TODO: there is something wrong with this check
    #   don't know exatcly what, test it better...
    if !child.is_a?(Ferdinand::Ast::Node)
      raise TypeError.new("child[#{child.class}] is not a Node")
    end
    children << child

    self
  end

  def each(...)
    children.each(...)
  end

  def empty?
    children.empty?
  end

  def ==(other)
    return false if self.class != other.class

    name == other.name && children == other.children
  end

  def pretty_print(q)
    p = Parser::Printer.new(q)
    p.text "<", name, ">"
    p.children self
  end

  protected

  def children
    @children ||= []
  end
end
