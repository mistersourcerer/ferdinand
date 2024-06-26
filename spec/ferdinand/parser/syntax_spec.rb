require "ferdinand/parser/ast/pin"

RSpec.describe Syntax do
  let(:tokenizer) { Scanner::Tokenizer.new(fixture("not.hdl")) }

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

  subject(:parser) { described_class.new tokenizer }

  describe "#analyse" do
    it "returns the adequate AST given a valid source hdl file" do
      expect(parser.analyse).to eq ast
    end
  end
end
