require "spec_helper"

describe Crunch do
  describe ".table" do
    it "validates arguments" do
      assert_raises(ArgumentError) do
        Crunch.table 348
      end
    end

    it "can accept a csv path" do
      table = Crunch.table( File.expand_path("../data/test.csv", __FILE__) )
      table.first['domain'].must_equal "example.com"
    end

    it "can accept an array of hashes" do
      table = Crunch.table( [{:domain => "example.com", :visits => "5"}] )
      table.first[:domain].must_equal "example.com"
    end

    it "can take a block that typecasts columns" do
      table = Crunch.table( File.expand_path("../data/test.csv", __FILE__) ) do
        date    'date'
        integer 'impressions', 'conversions'
        float   'payout'
      end

      table.first['date'].must_equal Date.parse('2010-01-01')
      table.first['impressions'].must_equal 500
      table.first['conversions'].must_equal 20
      table.first['payout'].must_equal 15.0
    end

    it "can take a block that transforms columns" do
      table = Crunch.table( File.expand_path("../data/test.csv", __FILE__) ) do
        transform('payout') do |val|
          val.to_f + 2
        end

        transform('impressions', 'conversions') { |v| v.to_i + 100 }
      end

      table.first['payout'].must_equal 17.0
      table.first['impressions'].must_equal 600
      table.first['conversions'].must_equal 120
    end

    it "can take a block that transforms rows" do
      table = Crunch.table( File.expand_path("../data/test.csv", __FILE__) ) do
        integer 'conversions'
        transform('impressions', &:to_f)
        transform do |row|
          row['conversion_rate'] = row['conversions'] / row['impressions']
        end
      end

      table.first['conversion_rate'].must_equal 0.04
    end
  end
end

