require "test_helper"
class TestCrunch < Test::Unit::TestCase
  def test_invalid_arg
    assert_raise(ArgumentError) do
      Crunch.table 348
    end
  end

  def test_load_csv
    table = Crunch.table( File.expand_path("../data/test.csv", __FILE__) )
    assert_equal "example.com", table.first['domain']
  end

  def test_load_hash
    table = Crunch.table( [:domain => "example.com", :visits => "5"] )
    assert_equal "example.com", table.first[:domain]
  end

  def test_conversions
    table = Crunch.table( File.expand_path("../data/test.csv", __FILE__) ) do
      date    'date'
      integer 'impressions', 'conversions'
      float   'payout'
    end

    assert_equal Date.parse('2010-01-01'), table.first['date']
    assert_equal 500, table.first['impressions']
    assert_equal 20, table.first['conversions']
    assert_equal 15.0, table.first['payout']
  end

  def test_transform_columns
    table = Crunch.table( File.expand_path("../data/test.csv", __FILE__) ) do
      transform('payout') do |val|
        val.to_f + 2
      end

      transform('impressions', 'conversions') { |v| v.to_i + 100 }
    end

    assert_equal 17.0, table.first['payout']
    assert_equal 600, table.first['impressions']
    assert_equal 120, table.first['conversions']
  end

  def test_transform_rows
    table = Crunch.table( File.expand_path("../data/test.csv", __FILE__) ) do
      integer 'conversions'
      transform('impressions', &:to_f)
      transform do |row|
        row['conversion_rate'] = row['conversions'] / row['impressions']
      end
    end

    assert_equal 0.04, table.first['conversion_rate']
  end
end
