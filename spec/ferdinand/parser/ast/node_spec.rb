class ChildOne < Parser::Ast::Node; end

class ChildTwo < Parser::Ast::Node; end

RSpec.describe Parser::Ast::Node do
  subject(:node) { described_class.new }

  context "Enumerable" do
    before do
      node << ChildOne.new
      node << ChildTwo.new
    end

    it "should have correct #count" do
      expect(node.count).to eq 2
    end

    it "should allow #map over children" do
      children_names = node.map { |n| n.class.name.split("::").last }

      expect(children_names).to eq ["ChildOne", "ChildTwo"]
    end
  end
end
