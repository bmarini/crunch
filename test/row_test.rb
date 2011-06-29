require "test_helper"
class TestCrunchRow < MiniTest::Unit::TestCase
  def test_create_row_from_hash
    hsh = ActiveSupport::OrderedHash.new
    hsh['foo'] = 'bar'
    hsh[:bee]  = 'boo'

    row = Crunch::Row[hsh]
    assert_equal 'bar', row['foo']
    assert_equal 'boo', row[:bee]

    row['foo'] = 'baz'
    assert_equal 'baz', row['foo']
    assert_equal ['baz', 'boo'], row.fields
  end
end