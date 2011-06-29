require "test_helper"
class TestSummary < MiniTest::Unit::TestCase
  def test_summary_table
    table = Crunch.table( File.expand_path("../data/test.csv", __FILE__) )
    # table.aggregate do
    #   group { |r| 'date' }
    #   sum('impressions')
    #   average('conversions')
    #   inject('')
    # end
    grouped = table.group_by { |r| r['date'] }
    assert_equal 2, grouped['2010-01-01'].size
    assert_equal 2, grouped['2010-01-02'].size
    assert_equal 2, grouped['2010-01-03'].size
  end
end