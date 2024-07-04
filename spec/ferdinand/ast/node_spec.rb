class OneChild < Ferdinand::Ast::Node; end

class AnotherChild < Ferdinand::Ast::Node; end

RSpec.describe Ferdinand::Ast::Node do
  subject(:node) { described_class.new("A Root Node") }
  let(:one_child) { OneChild.new }
  let(:another_child) { AnotherChild.new }
  let(:pure_node) { described_class.new("pure node") }

  context "Enumerable" do
    before do
      node << one_child
      node << another_child
      node << pure_node
    end

    describe "#<<" do
      it "raises TypeError for objects that are not nodes" do
        expect { node << 1 }.to raise_error TypeError
        expect { node << "not a node" }
          .to raise_error "child[String] is not a Node"
      end
    end

    describe "#to_a" do
      it "should add child nodes to the target" do
        expect(node.to_a).to eq [one_child, another_child, pure_node]
      end
    end

    describe "#count" do
      it "knows how many children are in an instance" do
        expect(node.count).to eq 3
      end
    end

    describe "empty?" do
      it "knows how many children are in an instance" do
        expect(node.empty?).to eq false
        expect(one_child.empty?).to eq true
      end
    end
  end
end
