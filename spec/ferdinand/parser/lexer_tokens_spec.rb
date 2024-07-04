RSpec.describe Ferdinand::Parser::Lexer do
  def tokens(source, klass = described_class)
    lexer = klass.new(source)
    lexer.tokens
  end

  describe "identifiers" do
    it "knows identifiers" do
      source = "NandToTetris"

      expect(tokens(source)).to eq [
        token(
          :ident,
          line: 1,
          column: 1,
          source: "NandToTetris",
          value: "NandToTetris"
        )
      ]
    end

    it "recognizes multiple identifiers separated by space" do
      source = "Nand To Tetris"

      expect(tokens(source)).to eq [
        token(:ident, line: 1, column: 1, source: "Nand", value: "Nand"),
        token(:ident, line: 1, column: 6, source: "To", value: "To"),
        token(:ident, line: 1, column: 9, source: "Tetris", value: "Tetris")
      ]
    end

    it "ignores extra spaces between identifiers" do
      source = "Nand    To        Tetris"

      expect(tokens(source)).to eq [
        token(:ident, line: 1, column: 1, source: "Nand", value: "Nand"),
        token(:ident, line: 1, column: 9, source: "To", value: "To"),
        token(:ident, line: 1, column: 19, source: "Tetris", value: "Tetris")
      ]
    end

    it "knows how to trim spaces" do
      source = "         Nand    To        Tetris      "

      expect(tokens(source)).to eq [
        token(:ident, line: 1, column: 10, source: "Nand", value: "Nand"),
        token(:ident, line: 1, column: 18, source: "To", value: "To"),
        token(:ident, line: 1, column: 28, source: "Tetris", value: "Tetris")
      ]
    end

    it "recognizes commas surrounded by spaces" do
      source = "NandTo , Tetris      "

      expect(tokens(source)).to eq [
        token(:ident, line: 1, column: 1, source: "NandTo", value: "NandTo"),
        token(:comma, line: 1, column: 8, source: ",", value: ","),
        token(:ident, line: 1, column: 10, source: "Tetris", value: "Tetris")
      ]
    end

    it "recognizes commas" do
      source = "NandTo,Tetris"

      expect(tokens(source)).to eq [
        token(:ident, line: 1, column: 1, source: "NandTo", value: "NandTo"),
        token(:comma, line: 1, column: 7, source: ",", value: ","),
        token(:ident, line: 1, column: 8, source: "Tetris", value: "Tetris")
      ]
    end

    it "recognizes semicolons" do
      source = "Nand;To ; Tetris"

      expect(tokens(source)).to eq [
        token(:ident, line: 1, column: 1, source: "Nand", value: "Nand"),
        token(:semi, line: 1, column: 5, source: ";", value: ";"),
        token(:ident, line: 1, column: 6, source: "To", value: "To"),
        token(:semi, line: 1, column: 9, source: ";", value: ";"),
        token(:ident, line: 1, column: 11, source: "Tetris", value: "Tetris")
      ]
    end

    it "recognizes colon" do
      source = "Nand:To : Tetris"

      expect(tokens(source)).to eq [
        token(:ident, line: 1, column: 1, source: "Nand", value: "Nand"),
        token(:colon, line: 1, column: 5, source: ":", value: ":"),
        token(:ident, line: 1, column: 6, source: "To", value: "To"),
        token(:colon, line: 1, column: 9, source: ":", value: ":"),
        token(:ident, line: 1, column: 11, source: "Tetris", value: "Tetris")
      ]
    end

    it "recognizes equals" do
      source = "Nand=To = Tetris"

      expect(tokens(source)).to eq [
        token(:ident, line: 1, column: 1, source: "Nand", value: "Nand"),
        token(:eq, line: 1, column: 5, source: "=", value: "="),
        token(:ident, line: 1, column: 6, source: "To", value: "To"),
        token(:eq, line: 1, column: 9, source: "=", value: "="),
        token(:ident, line: 1, column: 11, source: "Tetris", value: "Tetris")
      ]
    end
  end

  describe "reserved words" do
    it "recognizes CHIP" do
      source = "CHIP"

      expect(tokens(source)).to eq [
        token(:chip, line: 1, column: 1, source: "CHIP", value: "CHIP"),
      ]
    end

    it "recognizes IN" do
      source = "IN"

      expect(tokens(source)).to eq [
        token(:in, line: 1, column: 1, source: "IN", value: "IN"),
      ]
    end

    it "recognizes OUT" do
      source = "OUT"

      expect(tokens(source)).to eq [
        token(:out, line: 1, column: 1, source: "OUT", value: "OUT"),
      ]
    end

    it "recognizes PARTS" do
      source = "PARTS"

      expect(tokens(source)).to eq [
        token(:parts, line: 1, column: 1, source: "PARTS", value: "PARTS"),
      ]
    end

    it "recognizes BUILTIN" do
      source = "BUILTIN"

      expect(tokens(source)).to eq [
        token(:builtin, line: 1, column: 1, source: "BUILTIN", value: "BUILTIN"),
      ]
    end
  end
end
