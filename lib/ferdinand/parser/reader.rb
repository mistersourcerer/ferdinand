require "stringio"

class Ferdinand::Parser::Reader
  def initialize(input)
    @input = to_io_like(input)
  end

  def next
    return next_char if !@input.eof?

    nil if @current_char.nil?
  end

  def peek
    return @next_char if !@next_char.nil?

    @next_char = @input.getc
  end

  def peek?(*char)
    char.any? { |c| c == peek }
  end

  private

  def to_io_like(input)
    return input if input.respond_to?(:getc) && input.respond_to?(:eof?)
    # return File.new(input) if File.file?(input)

    # TODO: check if it is "castable" first,
    StringIO.new(input)
  end

  def next_char
    if @next_char.nil?
      @current_char = @input.getc
    else
      @current_char = @next_char
      @next_char = nil
    end

    @current_char
  end
end
