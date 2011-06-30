require "spec_helper"

describe Crunch::Table do
  it "will respond to enumerable methods" do
    table = Crunch.table( File.expand_path("../data/test.csv", __FILE__) )
    grouped = table.group_by { |r| r['date'] }
    grouped['2010-01-01'].size.must_equal 2
    grouped['2010-01-02'].size.must_equal 2
    grouped['2010-01-03'].size.must_equal 2
  end

  # TODO: Support this
  # table.aggregate do
  #   group_by('date')
  #   sum('impressions')
  #   average('conversions')
  #   standard_deviation('conversions')
  #   inject('')
  # end

  it "can aggregate" do
    table = Crunch.table( File.expand_path("../data/test.csv", __FILE__) ) do
      integer('impressions')
    end

    aggregated = table.aggregate do
      group_by 'date'
      sum('impressions')
    end

    aggregated.first['impressions'].must_equal 1100
  end
end