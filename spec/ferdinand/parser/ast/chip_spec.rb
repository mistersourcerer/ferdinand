RSpec.describe Ast::Chip do
  subject(:chip) {
    described_class.new("Not") {
      input Ast::Pin.new(:a), Ast::Pin.new(:b)
      output Ast::Pin.new(:out)
      part Ast::Part.new("Nand", pins: {
        a: Ast::Pin.new(:a),
        b: Ast::Pin.new(:b),
        out: Ast::Pin.new(:x)
      })

      part Ast::Part.new("Nand", pins: {
        a: Ast::Pin.new(:x),
        b: Ast::Pin.new(:x),
        out: Ast::Pin.new(:out)
      })
    }
  }

  describe ".initialize" do
    it "creates Pin nodes for the #in pins" do
      expect(chip.in.to_a).to eq [pin(:a), pin(:b)]
    end

    it "creates Pin nodes for the #out pins" do
      expect(chip.out.to_a).to eq [pin(:out)]
    end

    it "creates the parts for the chip" do
      expect(chip.parts.to_a).to eq [
        part("Nand", pins: {a: pin(:a), b: pin(:b), out: pin(:x)}),
        part("Nand", pins: {a: pin(:x), b: pin(:x), out: pin(:out)})
      ]
    end
  end
end
