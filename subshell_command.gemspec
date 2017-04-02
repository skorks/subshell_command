# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "subshell_command"
  spec.version       = "0.1.0"
  spec.authors       = ["Alan Skorkin"]
  spec.email         = ["alan@skorks.com"]

  spec.summary       = %q{Simpler way to execute shell commands from within ruby processes}
  spec.description   = %q{If, like me, you always forget when and how (and why) to
    use backticks or popen or whatever when trying to execute a shell command from
    within a ruby process, this should hopefully make life a little bit easier.}
  spec.homepage      = "https://github.com/skorks/subshell_command"
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
