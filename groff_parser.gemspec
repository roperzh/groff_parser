# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'groff_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "groff_parser"
  spec.version       = GroffParser::VERSION
  spec.authors       = ["Roberto Dip"]
  spec.email         = ["dip.jesusr@gmail.com"]
  spec.summary       = %q{Just a little gem to handle groff files}
  spec.description   = %q{Tiny library to parse groff files, with some handy metods to manage directories with a lot of files}
  spec.homepage      = "https://github.com/roperzh/groff_parser"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'minitest',      '~> 5'
  spec.add_development_dependency 'minitest-ansi', '~> 0.1.2'
  spec.add_development_dependency "inch"
end
