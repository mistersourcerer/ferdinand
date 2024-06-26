RSpec.describe Ferdinand::Scanner::Tokenizer do
  subject(:tokenizer) { described_class.new(fixture("valid.hdl")) }
  let(:tokens) { tokenizer.tokens }

  describe "#tokens" do
    it "find all tokens in the code" do
      expect(tokens.length).to eq 38
    end

    it "recognizes CHIP tokens" do
      token = tokens[1]

      expect(token.type).to eq :chip
    end

    it "recognizes identifier tokens" do
      expect(tokens[2].type).to eq :ident
    end

    it "recognizes brackets" do
      expect(tokens[3].type).to eq :openb
      expect(tokens.last.type).to eq :closeb
    end

    it "recognizes IN" do
      expect(tokens[4].type).to eq :in
    end

    it "recognizes comma" do
      expect(tokens[6].type).to eq :comma
    end

    it "recognizes semicolon" do
      expect(tokens[8].type).to eq :semi
    end

    it "recognizes OUT" do
      expect(tokens[10].type).to eq :out
    end

    it "recognizes PARTS:" do
      expect(tokens[14].type).to eq :parts
    end

    it "recognizes parenthesis" do
      expect(tokens[16].type).to eq :openp
      expect(tokens[34].type).to eq :closep
    end

    it "recognizes equals (=)" do
      expect(tokens[18].type).to eq :eq
    end

    it "recognizes square brackets" do
      expect(tokens[20].type).to eq :opens
      expect(tokens[22].type).to eq :closes
    end

    describe "comment" do
      it "recognizes classic comment" do
        expect(tokens.first).to eq token(
          :comment,
          line: 1,
          column: 1,
          source: "/*** ** valid hdl but bogus chip ** ***/",
          value: "** valid hdl but bogus chip **"
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
          value: "***  Now we have a multiline comment.  This will be ok too!  ***"
        )
      end

      it "recognizes line comment" do
        expect(tokens[-2]).to eq token(
          :comment,
          line: 14,
          column: 3,
          source: "// another valid comment is here",
          value: "another valid comment is here"
        )
      end
    end
  end
end
