module Ferdinand
  module Parser
    class Syntax
      def initialize(tokenizer)
        @tokenizer = tokenizer
      end

      def analyse
        root = Ast::Root.new

        while (token = tokenizer.next)
          next if token.type == :comment
          if token.type == :chip
            name = tokenizer.next
            # raise if !name.type == :ident
            tokenizer.next # openb = tokenizer.next
            # raise if openb.type != :openb
            root << build_chip(name)
          end
        end

        root
      end

      private

      attr_reader :tokenizer

      def error!(expected, token)
        error = "Expected a #{expected} but found #{token.value} at " \
          "[#{token.line}:#{token.column}]"
        raise SyntaxError.new(error)
      end

      def build_pins(part)
        name = nil

        while (token = tokenizer.next) && token.type != :closep
          next if token.type == :comma
          error!("pin identifier", token) if name.nil? && token.type != :ident

          if !name.nil?
            error!("=", token) if token.type != :eq
            error!("=[PIN NAME]", tokenizer.peek) if (peek = tokenizer.peek) && peek.type != :ident
            token = tokenizer.next
            part.pin(name, Ast::Pin.new(token.value))
            name = nil
          else
            name = token.value
          end
        end

        part
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
            chip.part build_pins(Ast::Part.new(name))

            name = nil
          end
        end
      end

      def attrs_of_chip
        @attrs_of_chip ||= %i[
          in out parts
        ]
      end

      def attr_of_chip?(token)
        attrs_of_chip.include? token.type
      end

      def next_attr(chip, token)
        if token.type == :in
          while (token = tokenizer.next) && token.type != :semi
            # raise if first iteration and no :ident
            next if token.type == :comma
            error!("identifier", token) if token.type != :ident

            chip.input Ast.Pin(token.value)
          end
        end

        if token.type == :out
          while (token = tokenizer.next) && token.type != :semi
            # raise if first iteration and no :ident
            next if token.type == :comma
            error!("identifier", token) if token.type != :ident

            chip.output Ast.Pin(token.value)
          end
        end

        if token.type == :parts
          build_parts(chip)
        end
      end

      def build_chip(name)
        chip = Ast::Chip.new(name.value)

        while (token = tokenizer.next) && token.type != :closeb
          if !attr_of_chip?(token)
            error = "Expected [#{token.value}] " \
              "to be part of #{name.value}<chip> at " \
              "[#{token.line}:#{token.column}]\n"
            error << "  parts of a chip are:\n"
            error << attrs_of_chip.reduce { |p| "    #{p}\n" }
            raise SyntaxError.new(error)
          end

          next_attr(chip, token)
        end

        chip
      end
    end
  end
end
