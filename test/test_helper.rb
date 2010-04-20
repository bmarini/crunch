require "test/unit"
require "crunch"

TestData = {
  :visits => [
    { :date => '2010-01-01', :domain => 'example.com', :visits => 500 },
    { :date => '2010-01-01', :domain => 'example.org', :visits => 600 },
    { :date => '2010-01-02', :domain => 'example.com', :visits => 700 },
    { :date => '2010-01-02', :domain => 'example.org', :visits => 800 },
    { :date => '2010-01-03', :domain => 'example.com', :visits => 900 },
    { :date => '2010-01-03', :domain => 'example.org', :visits => 1000 },
  ],
  :conversions => [
    { :date => '2010-01-01', :domain => 'example.com', :conversions => 20 },
    { :date => '2010-01-01', :domain => 'example.org', :conversions => 25 },
    { :date => '2010-01-02', :domain => 'example.com', :conversions => 30 },
    { :date => '2010-01-02', :domain => 'example.org', :conversions => 35 },
    { :date => '2010-01-03', :domain => 'example.com', :conversions => 40 },
    { :date => '2010-01-03', :domain => 'example.org', :conversions => 45 },
  ]
}