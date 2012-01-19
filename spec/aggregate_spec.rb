require "spec_helper"

describe Crunch::Table do
  it "will respond to enumerable methods" do
    table = Crunch.table( File.expand_path("../data/test.csv", __FILE__) )
    grouped = table.group_by { |r| r['date'] }
    grouped['2010-01-01'].size.must_equal 2
    grouped['2010-01-02'].size.must_equal 2
    grouped['2010-01-03'].size.must_equal 2
  end

  it "can aggregate" do
    table = Crunch.table( File.expand_path("../data/test.csv", __FILE__) ) do
      integer('impressions', 'conversions')
      float('payout')
    end

    aggregated = table.aggregate do
      group_by 'date'
      sum('impressions', 'payout')
      average('conversions')
      # TODO: Support renaming headers for each aggregated column, this will
      # allow aggregating the same column into two new columns
      # standard_deviation('conversions')
    end

    first = aggregated.find { |r| r['date'] == '2010-01-01' }
    first['impressions'].must_equal 1100
    first['conversions'].must_equal 22.5
    first['payout'].must_equal 30.5
  end
end