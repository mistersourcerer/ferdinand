class Ferdinand::Parser::Token
  attr_reader :type, :line, :column, :source, :value

  def initialize(type, line:, column:, source: nil, value: nil)
    @type = type
    @line = line
    @column = column
    @source = source
    @value = value
  end

  def ==(other)
    return false if !other.is_a?(self.class)

    type == other.type &&
      value == other.value &&
      line == other.line &&
      source == other.source &&
      column == other.column
  end

  def hash
    [self.class, type, value, line, source, column].hash
  end
end
