class CustomNode < Ferdinand::Parser::Ast::Node
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def ==(other)
    name == other.name
  end
end

RSpec.describe Ferdinand::Parser::Ast::Root do
  subject(:root) {
    described_class.new.tap { |ast|
      ast << CustomNode.new("omg")
      ast << CustomNode.new("lol")
    }
  }

  describe "#<<" do
    it "raises error if child is not a node" do
      expect { root << "omg" }.to raise_error TypeError
      expect { root << "omg" }.to raise_error "child[String] is not a Node"
    end
  end

  describe "#==" do
    it "returns true if both ASTs have equivalent children nodes" do
      ast = described_class.new
      ast << CustomNode.new("omg")
      ast << CustomNode.new("lol")

      expect(root).to eq ast
    end

    it "returns false for different ASTs" do
      ast = described_class.new
      ast << CustomNode.new("420")

      expect(root).to_not eq ast
    end
  end
end
