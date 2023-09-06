# frozen_string_literal: true

require_relative "lib/ferdinand/version"

Gem::Specification.new do |spec|
  spec.name = "ferdinand"
  spec.version = Ferdinand::VERSION
  spec.authors = ["Ricardo Valeriano"]
  spec.email = ["mister.sourcerer@gmail.com"]

  spec.summary = "Hardware simulator to follow the \"The Elements of Computing Systems\" work of art."
  spec.description = "Hardware simulator to follow the \"The Elements of Computing Systems\" work of art."
  spec.homepage = "https://github.com/mistersourcerer/ferdinand"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "zeitwerk", "~> 2.6"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
