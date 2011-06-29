require "test_helper"
class TestCrunchTable < MiniTest::Unit::TestCase
  def test_simple_usage
    table = Crunch::Table.new(['date', 'visits', 'conversions'])
    table << ["2010-01-01","14","10"]
    assert_equal "14", table.first['visits']
  end

  def test_with_transforms
    table = Crunch::Table.new(%w{date domain impressions conversions payout}) do
      date    'date'
      integer 'impressions'
      integer 'conversions'
      float   'payout'
    end

    table << {'date' => '2010-01-01', 'payout' => '5.0'}

    assert_equal Date.parse('2010-01-01'), table.first['date']
    assert_equal 0, table.first['impressions']
  end

  def test_transforms_with_block_arity
    foo = 'bar'

    table = Crunch::Table.new(%w{date domain impressions conversions payout}) do |t|
      t.transform { |r| r['foo'] = foo }
    end

    table << {'date' => '2010-01-01', 'payout' => '5.0'}

    assert_equal 'bar', table.first['foo']
  end

  def test_merging_datasets
    visits = Crunch.table(TestData[:visits])
    convrs = Crunch.table(TestData[:conversions])
    table  = visits.merge(convrs) { |r| [ r[:date], r[:domain] ] }

    assert_equal 500, table.first[:visits]
    assert_equal 20, table.first[:conversions]
  end
end

