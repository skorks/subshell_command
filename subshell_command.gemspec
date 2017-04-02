# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'subshell_command/version'

Gem::Specification.new do |spec|
  spec.name          = "subshell_command"
  spec.version       = SubshellCommand::VERSION
  spec.authors       = ["Alan Skorkin"]
  spec.email         = ["alan@skorks.com"]

  spec.summary       = %q{Simpler way to execute shell commands from within ruby processes}
  spec.description   = %q{Simpler way to execute shell commands from within ruby processes.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
