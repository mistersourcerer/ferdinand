RSpec.describe Ferdinand::Parser::Lexer do
  subject(:lexer) { described_class.new(fixture("valid.hdl")) }
  let(:tokens) { lexer.tokens }

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
      expect(lexer.next).to eq token(
        :comment,
        line: 1,
        column: 1,
        source: "/*** ** valid hdl but bogus chip ** ***/",
        value: "** valid hdl but bogus chip **"
      )

      expect(lexer.next).to eq token(
        :chip,
        line: 2,
        column: 1,
        source: "CHIP",
        value: "CHIP"
      )

      expect(lexer.next).to eq token(
        :ident,
        line: 2,
        column: 6,
        source: "KindaOk",
        value: "KindaOk"
      )
    end
  end

  describe "#current" do
    it "points to nil before it starts" do
      expect(lexer.current).to be_nil
    end

    it "points to current token, same one returned by #next" do
      token = lexer.next

      expect(token).to eq lexer.current
    end

    it "return nil after #next returns last token" do
      while lexer.next; end

      expect(lexer.current).to be_nil
    end
  end
end
