# frozen_string_literal: true

require "ferdinand"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  def fixture(file_rel_path)
    path = File.expand_path(file_rel_path, "./spec/fixtures")
    File.read(path)
  end

  def token(type, line:, column:, source: nil, value: nil)
    Ferdinand::Scanner::Token.new(
      type, line: line, column: column, value: value, source: source
    )
  end
end
