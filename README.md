# Crunch

Crunch is a library designed for working with datasets, specifically datasets
coming from database queries or CSV files.

## Goals

* Clean interface
* Easily load and merge data from arrays of hashes
* Leverage FasterCSV (or CSV in Ruby 1.9)
* Dump to CSV, ASCII table, or html, or other formats
* Do filters and transforms like Ruport
* Do summary tables easily
* Plug into js graphing libs easily! (graphael support)

## Examples

``` ruby
# Assuming a data.csv that contains:
#
# date,domain,impressions,conversions,payout
# 2010-01-01,example.com,500,20,15.0
# 2010-01-01,example.org,600,25,15.5
# 2010-01-02,example.com,700,30,16.0
# 2010-01-02,example.org,800,35,16.5
# 2010-01-03,example.com,900,40,17.0
# 2010-01-03,example.org,1000,45,17.5

table = Crunch.table("data.csv") do
  date('date')
  integer('impressions', 'conversions')
  float('payout')
end

# You now have an instance of Crunch::Table. You can access it as an array of
# hashes
table.first['impressions'] # => 500

# You can also aggregate a table
summary = table.aggregate do
  group_by 'date'
  sum('impressions', 'payout')
  average('conversions')
end
```
