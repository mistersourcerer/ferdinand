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
          eat_spaces(char)
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
        char == "/" && reader.peek?("*")
      end

      def separator?(char)
        char == "," || char == ";"
      end

      def token_finished?
        separator?(reader.peek) || reader.peek?(nil, "\s", "\n")
      end

      def next_line
        @line += 1
        @column = 0
      end

      def eat_spaces(char)
        while reader.peek?("\s")
          read!
        end
      end

      def token(word, started_at: {}, type: nil, source: nil)
        started_at = {
          line: started_at.fetch(:line) { @line },
          column: started_at.fetch(:column) { @column }
        }

        if !token_finished?
          while (char = read!)
            word << char
            break if token_finished?
          end
        end

        Token.new(
          type || :word,
          line: started_at[:line],
          column: started_at[:column],
          source: source || word,
          value: word
        )
      end

      def comment_token(open = "/")
        started_at = {line: @line, column: @column}
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

        token(comment, started_at: started_at, type: :comment, source: source)
      end
    end
  end
end
