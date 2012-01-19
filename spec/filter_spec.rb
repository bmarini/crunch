require "spec_helper"

describe Crunch::Table do
  it "can filter" do
    table = Crunch.table( File.expand_path("../data/test.csv", __FILE__) ) do
      filter { |row| row['domain'] == "example.com" }
    end

    table.all? { |row| row['domain'] == "example.org" }.must_equal true
  end
end