require "spec_helper"

describe Crunch::Row do
  it "can be initialized from a hash" do
    hsh = Crunch::OrderedHash.new
    hsh['foo'] = 'bar'
    hsh[:bee]  = 'boo'

    row = Crunch::Row[hsh]
    row['foo'].must_equal 'bar'
    row[:bee].must_equal 'boo'

    row['foo'] = 'baz'
    row['foo'].must_equal 'baz'
    row.fields.must_equal ['baz', 'boo']
  end
end