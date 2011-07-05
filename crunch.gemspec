# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "crunch/version"

Gem::Specification.new do |s|
  s.name             = "crunch"
  s.version          = Crunch::VERSION
  s.date             = "2011-06-26"
  s.summary          = "Crunch crunches data"
  s.email            = "bmarini@gmail.com"
  s.homepage         = "http://github.com/bmarini/crunch"
  s.description      = "Reporing library for loading, manipulating,\
aggregating and formatting tabular data"
  s.authors          = ["Ben Marini"]

  s.add_dependency "fastercsv" if RUBY_VERSION < "1.9"
  s.add_dependency "mathstats"
  s.add_development_dependency "minitest", "~> 2.3.0"
  s.add_development_dependency "activesupport", "~> 3.0.0"
  s.add_development_dependency "rake", "~> 0.9.2"

  s.has_rdoc         = true
  s.extra_rdoc_files = ["README.md"]
  s.rdoc_options     = ["--main", "README.md"]

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
