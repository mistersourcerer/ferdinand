RSpec.describe Ferdinand::Scanner::Tokenizer do
  describe "locations" do
    subject(:tokens) { described_class.new(fixture("valid.hdl")).tokens }

    it "knows the line where tokens were found" do
      out_token = tokens[10]

      expect(out_token.line).to eq 5
    end

    it "knows the column where tokens start at" do
      out_token = tokens[10]

      expect(out_token.column).to eq 3
    end
  end

  describe "#tokens" do
    subject(:tokens) { described_class.new(fixture("valid.hdl")).tokens }

    it "find all tokens in the code" do
      expect(tokens.length).to eq 14
    end

    describe "comment" do
      it "recognizes classic comment" do
        expect(tokens.first).to eq token(
          :comment,
          line: 1,
          column: 1,
          source: "/*** * valid hdl but bogus chip * ***/",
          value: " * valid hdl but bogus chip * "
        )
      end
    end
  end
end
