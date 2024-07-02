RSpec.describe Ferdinand::Parser::Ast::Pin do
  subject(:pin) { described_class.new(:out) }

  describe "Ast.Pin" do
    it "shortcut for creating a Pin" do
      expect(Ast.Pin(:lol)).to eq described_class.new(:lol)
    end

    it "just returns if parameter is already a Pin" do
      pin = described_class.new(:lol)
      expect(Ast.Pin(pin)).to be pin
    end
  end

  describe ".new" do
    it "create a Pin with a specific name" do
      expect(described_class.new(:omg).name).to eq "omg"
    end
  end

  describe "#size" do
    it "returns 1 by default" do
      expect(pin.size).to eq 1
    end

    it "changes with #size=" do
      pin.size = 5
      expect(pin.size).to eq 5
    end
  end
end
