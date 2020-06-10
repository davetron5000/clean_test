# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "clean_test/version"

Gem::Specification.new do |s|
  s.name        = "clean_test"
  s.version     = Clean::Test::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["David Copeland"]
  s.email       = ["davetron5000@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Clean up your Test::Unit tests}
  s.description = %q{You can easily make your plain Ruby Test::Unit test cases clean and clear with Given/When/Then, placeholder values, and textual descriptions without resorting to metaprogramming or complex frameworks.  Use as much or as little as you like}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency("faker", "~> 2.12.0")
  s.add_dependency("test-unit")
  s.add_development_dependency("rdoc")
  s.add_development_dependency("sdoc")
  s.add_development_dependency("rake")
  s.add_development_dependency("simplecov")
end
