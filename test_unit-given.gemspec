# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "test/unit/given/version"

Gem::Specification.new do |s|
  s.name        = "test_unit-given"
  s.version     = Test::Unit::Given::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["David Copeland"]
  s.email       = ["davetron5000@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Use Given/When/Then in your Test::Unit tests}
  s.description = %q{We don't need no stinkin' RSpec!  Get all the fluency you want in your Test::Unit tests, with no magic required, using straight Ruby syntax}

  s.rubyforge_project = "test_unit-given"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency("faker")
  s.add_development_dependency("rdoc")
  s.add_development_dependency("rake")
  s.add_development_dependency("simplecov")
end
