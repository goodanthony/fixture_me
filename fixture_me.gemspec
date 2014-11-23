# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fixture_me/version'

Gem::Specification.new do |spec|
  spec.name          = "fixture_me"
  spec.version       = FixtureMe::VERSION
  spec.authors       = ["anthony de silva"]
  spec.email         = ["anthony@iamfree.com"]
  spec.summary       = %q{Generate fixtures and fixture files for testing}
  spec.description   = %q{If you want to generate fixtures from development database for a Ruby on Rails application here is a helper}
  spec.homepage      = "https://github.com/iamfree-com/fixture_me"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
