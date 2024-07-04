Gem::Specification.new do |spec|
  spec.name          = "invasion_editor"
  spec.version       = "0.1.0"
  spec.authors       = ["Blade of Maya"]
  spec.email         = ["hey@bladeofmaya.com"]

  spec.summary       = %q{Scans multiple video files for the start and end of invasions and creates signle clips.}
  spec.description   = %q{Longer description of your gem}
  spec.homepage      = "https://github.com/bladeofmaya/invasion_editor"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*", "MIT-LICENSE", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
end
