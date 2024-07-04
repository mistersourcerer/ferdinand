RSpec.describe Ferdinand::Parser::Token do
  subject(:comment) {
    described_class.new(
      :comment,
      line: 4,
      column: 20,
      value: "it is a comment",
      source: "/* it is a comment */"
    )
  }

  describe "#==" do
    it "considers two equivalent comments as equals" do
      expect(comment).to eq token(
        :comment,
        line: 4,
        column: 20,
        value: "it is a comment",
        source: "/* it is a comment */"
      )
    end
  end

  describe "#hash" do
    it "consistently generates hashes based on content" do
      expect(comment.hash).to eq token(
        :comment,
        line: 4,
        column: 20,
        source: "/* it is a comment */",
        value: "it is a comment"
      ).hash
    end
  end
end
