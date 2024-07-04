module Ferdinand::Parser
  class Lexer
    include Enumerable
    attr_reader :line, :column, :current

    def initialize(code)
      @reader = Ferdinand::Reader.new(code)
      @line = 1
      @column = 0
      @current = nil
    end

    def next
      @current = to_enum.next
    rescue StopIteration
      @current = nil
    end

    def peek
      to_enum.peek
    rescue StopIteration
      nil
    end

    def to_enum
      @enum ||= super
    end

    def tokens
      to_a
    end

    def each
      return to_enum if !block_given?

      while (token = next_token)
        yield(token)
      end
    end

    private

    attr_reader :reader

    def read!
      reader.next.tap { |char|
        @column += 1 if !char.nil?
      }
    end

    def next_token
      return if reader.eof?

      char = read!
      if char.nil?
        return
      elsif char == "\s"
        eat_spaces
        next_token
      elsif separator?(char)
        token(char)
      else
        token(char)
      end
    end

    # def next_token
    #   char = read!

    #   if char.nil?
    #     nil
    #   elsif char == "\n"
    #     next_line
    #     next_token
    #   elsif char == "\s"
    #     eat_spaces
    #     next_token
    #   elsif separator?(char)
    #     token(char)
    #   elsif comment?(char)
    #     comment_token(char)
    #   else
    #     token(char)
    #   end
    # end

    # def comment?(char)
    #   char == "/" && (reader.peek?("*") || reader.peek?("/"))
    # end

    def separator?(char)
      char == "," ||
        char == ";" ||
        char == ":" ||
        char == "="
    end

    def delimiter?(char)
      separator?(char) ||
        char == "{" || char == "}" ||
        char == "[" || char == "]" ||
        char == "(" || char == ")" ||
        char == "="
    end

    def token_finished?
      separator?(reader.peek) ||
        delimiter?(reader.peek) ||
        reader.peek?("\s", "\n")
    end

    # def next_line
    #   @line += 1
    #   @column = 0
    # end

    def eat_spaces
      while reader.peek?("\s")
        space = read!
        yield(space) if block_given?
      end
    end

    def token_type_for(word)
      @types ||= {
        "CHIP" => :chip,
        "IN" => :in,
        "OUT" => :out,
        "PARTS" => :parts,
        "BUILTIN" => :builtin,
        "{" => :openb,
        "}" => :closeb,
        "(" => :openp,
        ")" => :closep,
        "[" => :opens,
        "]" => :closes,
        "," => :comma,
        ";" => :semi,
        ":" => :colon,
        "=" => :eq
      }

      @types.fetch(word) { :ident }
    end

    def token(word, started_at: {}, type: nil, source: nil)
      started_at = {
        line: started_at.fetch(:line) { @line },
        column: started_at.fetch(:column) { @column }
      }

      if !separator?(word) && !token_finished?
        while (char = read!)
          word << char
          break if token_finished?
        end
      end

      Token.new(
        type || token_type_for(word),
        line: started_at[:line],
        column: started_at[:column],
        source: source || word,
        value: word
      )
    end
  end
end
