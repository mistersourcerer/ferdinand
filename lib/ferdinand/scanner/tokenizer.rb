module Ferdinand
  module Scanner
    class Tokenizer
      def initialize(code)
        @reader = Reader.new(code)
        @line = 1
        @column = 0
      end

      def tokens
        tokens = []

        while (token = next_token)
          tokens << token
        end

        tokens
      end

      private

      attr_reader :reader

      def next_token
        char = reader.next
        @column += 1

        if char.nil?
          nil
        elsif char == "\n"
          next_line
          next_token
        elsif char == "\s"
          eat_spaces(char)
          next_token
        elsif separator?(char)
          separator_token(char)
        elsif comment?(char)
          comment_token(char)
        else
          token(char)
        end
      end

      def next_line
        @line += 1
        @column = 0
      end

      def comment?(char)
        char == "/" && reader.peek == "*"
      end

      def separator?(char)
        char == "," || char == ";"
      end

      def separator_token(char)
        Token.new(
          :separator,
          line: @line,
          column: @column,
          source: char,
          value: char
        )
      end

      def eat_spaces(char)
        while reader.peek == "\s"
          reader.next
          @column += 1
        end
      end

      def token_finished?
        separator?(reader.peek) ||
          reader.peek == "\s" ||
          reader.peek == "\n" ||
          reader.peek.nil?
      end

      def token(char)
        started_at = {line: @line, column: @column}
        word = char

        if !token_finished?
          while (char = reader.next)
            @column += 1
            word << char
            break if token_finished?
          end
        end

        word_token(started_at, word)
      end

      def word_token(started_at, word)
        # TODO: good spot to check if `word` is a keyword, etc...
        Token.new(
          :word,
          line: started_at[:line],
          column: started_at[:column],
          source: word,
          value: word
        )
      end

      def comment_token(open = "/")
        started_at = {line: @line, column: @column}
        source = open
        comment = ""

        while (char = reader.next)
          if char == "\n"
            next_line
            next
          end

          @column += 1
          source << char
          next if comment.empty? && char == "*"
          break if char == "/"

          if char == "*"
            stars = ""
            while reader.peek == "*"
              stars << reader.next
              @column += 1
            end

            if reader.peek == "/"
              source << stars
            else
              comment << stars
            end
          else
            comment << char
          end
        end

        Token.new(
          :comment,
          line: started_at[:line],
          column: started_at[:column],
          source: source,
          value: comment
        )
      end
    end

    class Reader
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

      def current
        @current_char
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
  end
end
