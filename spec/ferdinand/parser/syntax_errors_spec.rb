require "ferdinand/parser/ast/pin"

RSpec.shared_examples "parsing error" do
  it "raises SyntaxError" do
    expect { subject.analyse }.to raise_error(SyntaxError, error)
  end
end

RSpec.describe Syntax, "Errors" do
  let(:tokenizer) { Scanner::Tokenizer.new(source) }
  subject { described_class.new tokenizer }

  describe "missing right bracket" do
    let(:source) { fixture("errors/missing_bracket.hdl") }
    let(:error) do
      "Expected a << } >> but none was found at [7:1]"
    end

    it_behaves_like "parsing error"
  end

  describe "missing left bracket" do
    let(:source) { fixture("errors/missing_open_bracket.hdl") }
    let(:error) do
      "Expected a << { >> but found << IN >> at [2:5]"
    end

    it_behaves_like "parsing error"
  end

  describe "missing chip name" do
    let(:source) { fixture("errors/missing_chip_name.hdl") }
    let(:error) do
      "Expected a << NAME[str] >> but found << { >> at [1:6]"
    end

    it_behaves_like "parsing error"
  end
end
