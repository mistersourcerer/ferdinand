require "ferdinand/parser/ast/pin"

RSpec.describe Syntax do
  subject(:parser) { described_class.new tokenizer }

  let(:hdl) { fixture("not.hdl") }
  let(:tokenizer) { Scanner::Tokenizer.new(hdl) }
  let(:ast) {
    Ast::Root.new(
      Ast::Chip.new("Not") {
        input Ast::Pin.new(:in)
        input Ast::Pin.new(:another), Ast::Pin.new(:yet_another)
        input Ast::Pin.new(:something)

        output Ast::Pin.new(:out)

        part Ast::Part.new("Nand", pins: {
          a: Ast::Pin.new(:in),
          b: Ast::Pin.new(:in),
          out: Ast::Pin.new(:out)
        })
      }
    )
  }

  describe "#analyse" do
    it "returns the adequate AST given a valid source hdl file" do
      expect(parser.analyse).to eq ast
    end
  end

  context "buses recognition" do
    subject(:ast) { parser.analyse }

    let(:hdl) { fixture("buses.hdl") }
    let(:buses_chip) {
      Ast::Root.new(
        Ast::Chip.new("BusesFakeChip") {
          input Ast::Pin.new(:a, size: 16)
          input Ast::Pin.new(:a, size: 16)
          input Ast::Pin.new(:sel)
          output Ast::Pin.new(:out, size: 16)
        }
      )
    }

    it "should recognize a bus pin" do
      expect(ast).to eq buses_chip
    end
  end
end
