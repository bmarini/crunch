Gem::Specification.new do |s|
  s.name             = "crunch"
  s.version          = "0.0.1"
  s.date             = "2010-04-17"
  s.summary          = "Crunch crunches data"
  s.email            = "bmarini@gmail.com"
  s.homepage         = "http://github.com/bmarini/crunch"
  s.description      = "Reporing library for loading, manipulating,\
aggregating and formatting tabular data"
  s.has_rdoc         = true
  s.rdoc_options     = ["--main", "README.txt"]
  s.authors          = ["Ben Marini"]
  s.files            = [
    "README.txt",
    "Rakefile",
    "crunch.gemspec",
    "lib/crunch.rb",
    "lib/crunch/row.rb",
    "lib/crunch/table.rb"
  ]
  s.test_files       = ["test/crunch_test.rb"]
  s.extra_rdoc_files = ["README.txt"]
end
