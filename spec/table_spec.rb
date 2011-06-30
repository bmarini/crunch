require "spec_helper"

describe Crunch::Table do
  it "must be initialized with an array of headers" do
    table = Crunch::Table.new(['date', 'visits', 'conversions'])
    table.headers.must_equal ['date', 'visits', 'conversions']
  end

  it "can append rows from arrays" do
    table = Crunch::Table.new(['date', 'visits', 'conversions'])
    table << ["2010-01-01","14","10"]
    table.first['visits'].must_equal "14"
  end

  it "can append rows from hashes" do
    table = Crunch::Table.new(['date', 'visits', 'conversions'])
    table << {'date' => '2010-01-01', 'visits' => '14', 'conversions' => '10'}
    table.first['visits'].must_equal "14"
  end

  it "can initialize with a block of typecasts" do
    table = Crunch::Table.new(%w{date domain impressions conversions payout}) do
      date    'date'
      integer 'impressions'
      integer 'conversions'
      float   'payout'
    end

    table << {'date' => '2010-01-01', 'payout' => '5.0'}

    table.first['date'].must_equal Date.parse('2010-01-01')
    table.first['impressions'].must_equal 0
  end

  it "can initialize with a block arity of 0 or 1" do
    foo = 'bar'

    table = Crunch::Table.new(%w{date domain impressions conversions payout}) do |t|
      t.transform { |r| r['foo'] = foo }
    end

    table << {'date' => '2010-01-01', 'payout' => '5.0'}

    table.first['foo'].must_equal 'bar'
  end

  it "can merge datasets" do
    visits = Crunch.table(TestData[:visits])
    convrs = Crunch.table(TestData[:conversions])
    table  = visits.merge(convrs) { |r| [ r[:date], r[:domain] ] }

    table.first[:visits].must_equal 500
    table.first[:conversions].must_equal 20
  end
end

