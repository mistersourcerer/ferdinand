module Ferdinand
  module Parser
    module Ast
      class NotComparableError < StandardError; end

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

      class Root < Node
        def initialize(node = nil)
          self << node if !node.nil?
        end

        def ==(other)
          return false if self.class != other.class

          children == other.children
        end
      end

      class Pin < Node
        attr_reader :name

        def initialize(name)
          @name = String(name)
        end

        def ==(other)
          return false if self.class != other.class

          name == other.name
        end
      end

      def self.Pin(name)
        return name if name.is_a?(Pin)

        Pin.new(name)
      end

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
  end
end
