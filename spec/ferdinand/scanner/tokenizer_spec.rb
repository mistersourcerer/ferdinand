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
      expect(tokens.length).to eq 15
    end

    describe "comment" do
      it "recognizes classic comment" do
        expect(tokens.first).to eq token(
          :comment,
          line: 1,
          column: 1,
          source: "/*** ** valid hdl but bogus chip ** ***/",
          value: " ** valid hdl but bogus chip ** "
        )
      end

      it "recognizes a multiline comment" do
        multiline_comment = tokens[13]

        expect(multiline_comment).to eq token(
          :comment,
          line: 6,
          column: 3,
          source: "/*** ***\n" \
            "  Now we have a multiline comment.\n" \
            "  This will be ok too!\n" \
            "  *** */",
          value: " ***  Now we have a multiline comment.  This will be ok too!  *** "
        )
      end
    end
  end
end
