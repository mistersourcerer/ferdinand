require "stringio"

class Ferdinand::Reader
  def initialize(input)
    @input = to_io_like(input)
  end

  def next
    @current_char = nil

    if @next_char.nil?
      return if @input.eof?
      @current_char = @input.getc
    else
      @current_char = @next_char
      @next_char = nil
    end

    @current_char
  end

  def peek
    return @next_char if !@next_char.nil?

    @next_char = @input.getc
  end

  def peek?(*char)
    char.any? { |c| c == peek }
  end

  def eof?
    @next_char.nil? && @input.eof?
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
      return if @input.eof?
      @current_char = @input.getc
    else
      @current_char = @next_char
      @next_char = nil
    end

    @current_char
  end
end
