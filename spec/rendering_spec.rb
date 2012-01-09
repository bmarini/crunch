require "spec_helper"

describe Crunch::Rendering do
  it "can render to string" do
    table = Crunch.table( File.expand_path("../data/test.csv", __FILE__) )
    res = table.as(:str)

    res.must_equal <<-EOS.strip + "\n"
+------------+-------------+-------------+-------------+--------+
| date       | domain      | impressions | conversions | payout |
+------------+-------------+-------------+-------------+--------+
| 2010-01-01 | example.com | 500         | 20          | 15.0   |
| 2010-01-01 | example.org | 600         | 25          | 15.5   |
| 2010-01-02 | example.com | 700         | 30          | 16.0   |
| 2010-01-02 | example.org | 800         | 35          | 16.5   |
| 2010-01-03 | example.com | 900         | 40          | 17.0   |
| 2010-01-03 | example.org | 1000        | 45          | 17.5   |
+------------+-------------+-------------+-------------+--------+
    EOS
  end

  it "can render to json" do
    table = Crunch.table( File.expand_path("../data/test.csv", __FILE__) )
    res = table.as(:json)
    res.must_equal '[{"date":"2010-01-01","domain":"example.com","impressions":"500","conversions":"20","payout":"15.0"},{"date":"2010-01-01","domain":"example.org","impressions":"600","conversions":"25","payout":"15.5"},{"date":"2010-01-02","domain":"example.com","impressions":"700","conversions":"30","payout":"16.0"},{"date":"2010-01-02","domain":"example.org","impressions":"800","conversions":"35","payout":"16.5"},{"date":"2010-01-03","domain":"example.com","impressions":"900","conversions":"40","payout":"17.0"},{"date":"2010-01-03","domain":"example.org","impressions":"1000","conversions":"45","payout":"17.5"}]'
  end
end