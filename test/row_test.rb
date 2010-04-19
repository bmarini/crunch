require "test_helper"
class TestCrunchRow < Test::Unit::TestCase
  def test_create_row_from_hash
    row = Crunch::Row['foo' => 'bar', :bee => 'boo']
    assert_equal 'bar', row['foo']
    assert_equal 'boo', row[:bee]

    row['foo'] = 'baz'
    assert_equal 'baz', row['foo']
    assert_equal ['baz', 'boo'], row.fields
  end
end