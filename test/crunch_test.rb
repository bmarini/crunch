require "test_helper"
class TestCrunch < Test::Unit::TestCase
  def test_method_access_for_rows
    row = Crunch::Row['foo' => 'bar', :bee => 'boo'].methodize_keys!
    assert_equal 'bar', row.foo
    assert_equal 'boo', row.bee

    row.foo = 'baz'
    assert_equal 'baz', row.foo
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
    
    assert_equal Date.parse('2010-01-01'), table.first.date
    assert_equal 500, table.first.impressions
    assert_equal 20, table.first.conversions
    assert_equal 15.0, table.first.payout
  end
  
  def test_transform_columns
    table = Crunch.table( File.expand_path("../data/test.csv", __FILE__) ) do
      transform('payout') do |val|
        val.to_f + 2
      end

      transform('impressions', 'conversions') { |v| v.to_i + 100 }
    end

    assert_equal 17.0, table.first.payout
    assert_equal 600, table.first.impressions
    assert_equal 120, table.first.conversions
  end
  
  def test_transform_rows
    table = Crunch.table( File.expand_path("../data/test.csv", __FILE__) ) do
      integer 'conversions'

      transform do |row|
        row['conversion_rate'] = row.conversions / row.impressions.to_f
      end
    end
    
    assert_equal 0.04, table.first.conversion_rate
  end
end

