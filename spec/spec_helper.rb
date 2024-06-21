# frozen_string_literal: true

require "ferdinand"

module Ferdinand::SpecHelper
  include Ferdinand
  include Ferdinand::Parser

  def fixture(file_rel_path)
    path = File.expand_path(file_rel_path, "./spec/fixtures")
    File.read(path)
  end

  def token(type, line:, column:, source: nil, value: nil)
    Scanner::Token.new(
      type, line: line, column: column, value: value, source: source
    )
  end

  def pin(name)
    Ast::Pin.new(name)
  end

  def part(name, **kwargs)
    Ast::Part.new(name, **kwargs)
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Ferdinand::SpecHelper

  # since those are meant as namespaces,
  # I am unashamed of this workaround for testing in here.
  include Ferdinand::Parser
  include Ferdinand
end
