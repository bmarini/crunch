require "spec_helper"

describe Crunch::Rendering do
  it "can render to string" do
    table = Crunch.table( File.expand_path("../data/test.csv", __FILE__) )
    stdout, stderr = capture_io do
      table.as(:str)
    end

    stdout.must_equal <<-EOS.strip + "\n"
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
end