RSpec.describe Ferdinand::Scanner::Tokenizer do
  subject(:tokenizer) { described_class.new(fixture("valid.hdl")) }
  let(:tokens) { tokenizer.tokens }

  describe "locations" do
    it "knows the line where tokens were found" do
      out_token = tokens[10]

      expect(out_token.line).to eq 5
    end

    it "knows the column where tokens start at" do
      out_token = tokens[10]

      expect(out_token.column).to eq 3
    end
  end

  describe "#next" do
    it "returns always the next token" do
      expect(tokenizer.next).to eq token(
        :comment,
        line: 1,
        column: 1,
        source: "/*** ** valid hdl but bogus chip ** ***/",
        value: "** valid hdl but bogus chip **"
      )

      expect(tokenizer.next).to eq token(
        :chip,
        line: 2,
        column: 1,
        source: "CHIP",
        value: "CHIP"
      )

      expect(tokenizer.next).to eq token(
        :ident,
        line: 2,
        column: 6,
        source: "KindaOk",
        value: "KindaOk"
      )
    end
  end
end
