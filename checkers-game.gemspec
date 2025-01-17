require_relative 'lib/checkers/version'

Gem::Specification.new do |spec|
  spec.name          = "checkers-game"
  spec.version       = Checkers::VERSION
  spec.authors       = ["Grzegorz Jakubiak"]
  spec.email         = ["grzegorz.jakubiak@outlook.com"]

  spec.summary       = %q{Game of checkers}
  spec.description   = %q{Game of checkers}
  spec.homepage      = "https://github.com/grzegorz-jakubiak/checkers-game"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_runtime_dependency 'zeitwerk', '~> 2.4'
  spec.add_runtime_dependency 'ruby2d', '~> 0.9.4'
end
