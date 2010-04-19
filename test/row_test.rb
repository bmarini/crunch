require "test_helper"
class TestCrunchRow < Test::Unit::TestCase
  def test_method_access_for_rows
    row = Crunch::Row['foo' => 'bar', :bee => 'boo'].methodize_keys!
    assert_equal 'bar', row.foo
    assert_equal 'boo', row.bee

    row.foo = 'baz'
    assert_equal 'baz', row.foo
  end
end