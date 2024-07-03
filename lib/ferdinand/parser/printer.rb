class Ferdinand::Parser::Printer
  def initialize(q)
    @q = q
  end

  def text(*text)
    text.each { |t| q.text t }
  end

  private

  attr_reader :q
end
