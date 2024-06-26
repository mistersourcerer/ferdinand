require "ferdinand/parser/ast/pin"

RSpec.describe Syntax, "Errors" do
  let(:tokenizer) { Scanner::Tokenizer.new(source) }
  let(:parser) { described_class.new tokenizer }

  context "missing right bracket" do
    let(:source) { fixture("errors/missing_bracket.hdl") }
    let(:error) do
      "Expected a << } >> but none was found at [7:1]"
    end

    it "raise error about missing closing bracket" do
      expect { parser.analyse }.to raise_error(SyntaxError, error)
    end
  end

  context "missing left bracket" do
    let(:source) { fixture("errors/missing_open_bracket.hdl") }
    let(:error) do
      "Expected a << { >> but found << IN >> at [2:5]"
    end

    it "raise error about missing closing bracket" do
      expect { parser.analyse }.to raise_error(SyntaxError, error)
    end
  end
end
