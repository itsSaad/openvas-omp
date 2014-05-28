# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
#require 'openvas-omp/version'

Gem::Specification.new do |spec|
  spec.name          = "openvas"
  spec.version       = 1.0
  spec.authors       = ["Saad Masood"]
  spec.email         = ["itsmesmd@gmail.com"]
  spec.description   = %q{Fork of Kost's openvas-omp gem}
  spec.summary       = %q{Summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails', '~> 4.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "jeweler", "~> 1.5.2"
  spec.add_development_dependency "shoulda", ">= 0"
  spec.add_development_dependency "rcov", ">= 0"
end