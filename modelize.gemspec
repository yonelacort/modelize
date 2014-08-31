# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'modelize/version'

Gem::Specification.new do |spec|
  spec.name          = "modelize"
  spec.version       = Modelize::VERSION
  spec.authors       = ["yone_lc"]
  spec.email         = ["yonelacort@gmail.com"]
  spec.summary       = %q{Ruby transformer from JSON, XML and CSV to instance class.}
  spec.description   = %q{It transform from objects or files in JSON, XML and CSV. With meta-programming techniques,
                          the classes are created and instanciated, with their corresponding attributes and hierarchy.}
  spec.homepage      = "https://github.com/yonelacort/modelize"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "virtus"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
end
