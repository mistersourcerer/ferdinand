RSpec.describe Ferdinand::Chip::Nand do
  subject(:nand) { described_class.new }

  it "returns #out == 0 if both input pins are 1" do
    out = nand.call(a: 1, b: 1)

    expect(out.out).to eq 0
  end

  it "returns #out == 1 when input pins are not both 1" do
    results = [
      {a: 0, b: 0},
      {a: 0, b: 1},
      {a: 1, b: 0}
    ].map { |inputs| nand.call(**inputs).out }

    expect(results).to eq [1, 1, 1]
  end
end
