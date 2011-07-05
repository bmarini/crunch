require 'forwardable'
require 'mathstats'
if RUBY_VERSION < "1.9"
  require 'fastercsv'
  CSV = FasterCSV
else
  require 'csv'
end

module Crunch
  autoload :Table, "crunch/table"
  autoload :Row, "crunch/row"
  autoload :Rendering, "crunch/rendering"

  module Renderers
    autoload :Base,   "crunch/renderers/base"
    autoload :String, "crunch/renderers/string"
    autoload :CSV,    "crunch/renderers/csv"
  end

  if RUBY_VERSION < "1.9"
    require "active_support/ordered_hash"
    OrderedHash = ActiveSupport::OrderedHash
  else
    OrderedHash = Hash
  end

  class << self
    # Convenience method to Crunch::Table.new
    # 1. String - assumes csv file
    # 2. Array of arrays ( parsed csv file )
    # 3. Array of hashes ( database resultset )
    #
    # Examples
    #
    # Crunch.table("filename.csv")
    # Crunch.table([['a','b','c'],[1,2,3],[4,5,6], ...])
    # Crunch.table([{"a" => 1, "b" => 2, "c" => 3}, ...])
    def table(arg, &block)
      if arg.is_a?(String)
        table(CSV.read(arg), &block)
      elsif arg.is_a?(Array) && arg.first.is_a?(Array)
        Table.new(arg.shift, &block).push(*arg)
      elsif arg.is_a?(Array) && arg.first.is_a?(Hash)
        Table.new(arg.first.keys, &block).push(*arg)
      else
        raise ArgumentError.new("Argument must be a string or an array of arrays or hashes")
      end
    end
  end
end