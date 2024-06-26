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

  context "errors" do
    let(:tokenizer) { Scanner::Tokenizer.new(source) }
    let(:parser) { described_class.new tokenizer }

    context "missing right bracket" do
      let(:source) { fixture("errors/missing_bracket.hdl") }
      let(:error) do
        "Expected a } [closing bracket] but none was found at[7:1]"
      end

      it "returns the adequate AST given a valid source hdl file" do
        expect { parser.analyse }.to raise_error(SyntaxError, error)
      end
    end
  end
end
