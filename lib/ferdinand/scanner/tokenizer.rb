module Ferdinand::Scanner
  class Tokenizer
    include Enumerable
    attr_reader :line, :column

    def initialize(code)
      @reader = Reader.new(code)
      @line = 1
      @column = 0
    end

    def next
      to_enum.next
    rescue StopIteration
      nil
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
      reader.next.tap { @column += 1 }
    end

    def next_token
      char = read!

      if char.nil?
        nil
      elsif char == "\n"
        next_line
        next_token
      elsif char == "\s"
        eat_spaces
        next_token
      elsif separator?(char)
        token(char)
      elsif comment?(char)
        comment_token(char)
      else
        token(char)
      end
    end

    def comment?(char)
      char == "/" && (reader.peek?("*") || reader.peek?("/"))
    end

    def separator?(char)
      char == "," || char == ";"
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
        reader.peek?(nil, "\s", "\n")
    end

    def next_line
      @line += 1
      @column = 0
    end

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
        "PARTS:" => :parts,
        "{" => :openb,
        "}" => :closeb,
        "(" => :openp,
        ")" => :closep,
        "[" => :opens,
        "]" => :closes,
        "," => :comma,
        ";" => :semi,
        "=" => :eq
      }

      @types.fetch(word) { :ident }
    end

    def token(word, started_at: {}, type: nil, source: nil)
      started_at = {
        line: started_at.fetch(:line) { @line },
        column: started_at.fetch(:column) { @column }
      }

      if !delimiter?(word) && !token_finished?
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

    def line_comment_token(open, started_at)
      source = open
      source << read!
      comment = ""

      while (char = read!)
        break if char == "\n"
        source << char
        comment << char
      end

      token(comment.strip, started_at: started_at, type: :comment, source: source)
    end

    def comment_token(open = "/")
      started_at = {line: @line, column: @column}
      return line_comment_token(open, started_at) if reader.peek?("/")

      source = open
      comment = ""
      while (char = read!)
        if char == "/" || reader.peek?("/")
          source << char
          source << read! if reader.peek?("/")
          break
        end

        if char == "\n"
          source << char
          next_line
          next
        end

        if char == "*" && reader.peek?("*")
          stars = char
          while reader.peek?("*")
            stars << read!
          end

          source << stars
          comment << stars if !comment.empty? && !reader.peek?("/")
          next
        end

        source << char
        comment << char
      end

      token(comment.strip, started_at: started_at, type: :comment, source: source)
    end
  end
end
