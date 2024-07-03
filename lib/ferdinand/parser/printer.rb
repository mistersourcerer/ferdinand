class Ferdinand::Parser::Printer
  def initialize(q)
    @q = q
  end

  def text(*text)
    text.each { |t| q.text t }
  end

  def space(identing = q.current_group.depth)
    q.text q.genspace.call(identing * 3)
  end

  def line
    text q.newline
  end

  def delimit(open: "[", close: "]")
    text open, q.newline
    yield if block_given?
    space(q.current_group.depth - 1)
    text close
  end

  def child(node)
    space
    q.group { node.pretty_print(q) }
  end

  def children(node)
    return if node.empty?

    delimit(open: "{", close: "}") do
      node.each do |c|
        child(c)
        line
      end
    end
    # text node.name
  end

  private

  attr_reader :q
end
