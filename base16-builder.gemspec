lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "base16/builder/version"

Gem::Specification.new do |spec|
  spec.name          = "base16-builder"
  spec.version       = Base16::Builder::VERSION
  spec.authors       = ["Robert Audi"]

  spec.summary       = %q{A Ruby implementation of a Base16 builder}
  spec.description   = %q{This is a base16 builder written in Ruby as defined by the base16 builder guidelines version 0.9.0}
  spec.homepage      = "https://github.com/RobertAudi/base16-builder"
  spec.license       = "WTFPL"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "fakefs", "~> 0.20.0"
  spec.add_development_dependency "pry", "~> 0.12.2"
  spec.add_development_dependency "pry-byebug", "~> 3.7.0"
end
