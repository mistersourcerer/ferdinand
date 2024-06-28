module Ferdinand
  module Parser
    class Syntax
      def initialize(tokenizer)
        @tokenizer = tokenizer
      end

      def analyse
        Ast::Root.new.tap { |root|
          while (token = tokenizer.next)
            next if token.type == :comment
            root << build_chip if token.type == :chip
          end
        }
      end

      private

      attr_reader :tokenizer

      def attrs_of_chip
        @attrs_of_chip ||= %i[
          in out parts
        ]
      end

      def attr_of_chip?(token)
        attrs_of_chip.include? token.type
      end

      def next_ident?
        (peek = tokenizer.peek) &&
          !peek.nil? &&
          peek.type == :ident
      end

      def error!(expected, token)
        error = "Expected a << #{expected} >> " \
          "but found << #{token.value} >> at [#{token.line}:#{token.column}]"
        raise SyntaxError.new(error)
      end

      def check_chip_closed!(token)
        if token.nil? || token.type != :closeb
          error = "Expected a << } >> but none was found at " \
            "[#{tokenizer.line}:#{tokenizer.column}]"
          raise SyntaxError.new(error)
        end
      end

      def check_chip_part!(token)
        if !attr_of_chip?(token)
          error = "Expected << #{token.value} >> " \
            "to be part of #{name.value}<chip> at " \
            "[#{token.line}:#{token.column}]\n"
          error << "  parts of a chip are:\n"
          error << attrs_of_chip.reduce { |p| "    #{p}\n" }
          raise SyntaxError.new(error)
        end
      end

      def build_pins(part)
        name = nil

        while (token = tokenizer.next) && token.type != :closep
          next if token.type == :comma
          error!("pin identifier", token) if name.nil? && token.type != :ident

          if !name.nil?
            error!("=", token) if token.type != :eq
            error!("=[PIN NAME]", tokenizer.peek) if !next_ident?
            token = tokenizer.next
            part.pin(name, token.value)
            name = nil
          else
            name = token.value
          end
        end
      end

      def build_parts(chip)
        while (peek = tokenizer.peek) && peek.type != :closeb
          name = nil
          while (token = tokenizer.next)
            next if token.type == :comment
            break if token.type == :semi
            if name.nil?
              name = token.value
              next
            end

            error!("part identifier", token) if name.nil? && token.type != :ident
            error!("(", token) if name.nil? && token.type != :openp
            part = Ast::Part.new(name).tap { |p| build_pins(p) }
            chip.part part
            name = nil
          end
        end
      end

      def next_attr(chip, token)
        if token.type == :in || token.type == :out
          type = token.type
          while (token = tokenizer.next) && token.type != :semi
            # raise if first iteration and no :ident
            next if token.type == :comma
            error!("identifier", token) if token.type != :ident
            pin_type = (type == :in) ? :input : :output
            chip.send pin_type, token.value
          end
        end

        build_parts(chip) if token.type == :parts
      end

      def build_chip
        name = tokenizer.next
        error!("NAME[str]", name) if name.type != :ident
        token = tokenizer.next
        error!("{", token) if token.type != :openb
        chip = Ast::Chip.new(name.value)

        chip.tap { |chip|
          while (token = tokenizer.next) && token.type != :closeb
            check_chip_part!(token)
            next_attr(chip, token)
          end
          check_chip_closed!(tokenizer.current)
        }
      end
    end
  end
end
