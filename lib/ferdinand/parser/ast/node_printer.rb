module Ferdinand::Parser::Ast
  class NodePrinter
    def initialize(node, q)
      @node, @q = node, q
    end

    def call
      return yield(self) if block_given?

      name
      children
      self
    end

    def text(*t)
      t.each { |t| q.text t }
    end

    def space
      q.text q.genspace.call(q.current_group.depth)
    end

    def line
      q.text q.newline
    end

    def child(node)
      space
      q.group { node.pretty_print(q) }
    end

    private

    attr_reader :node, :q

    def name
      @_name ||= node.class.name.split("::").last
      text @_name
      text "(", node.name.to_s, ")" if !node.name.nil?
      line
    end

    def children
      return if node.empty?

      q.group { node.each { |c| child(c) } }
    end
  end
end
