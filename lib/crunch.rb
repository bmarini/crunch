require 'forwardable'
autoload :CSV, "csv"

module Crunch
  autoload :Table, "crunch/table"
  autoload :Row, "crunch/row"
  
  class << self
    # Convenience method to Crunch::Table.new
    # 1. String - assumes csv file
    # 2. Array of arrays ( parsed csv file )
    # 3. Array of hashes ( database resultset )
    def table(arg, &block)
      if arg.is_a?(String)
        table(CSV.read(arg), &block)
      elsif arg.is_a?(Array) && arg.first.is_a?(Array)
        Table.new(arg.shift, &block).load(arg)
      elsif arg.is_a?(Array) && arg.first.is_a?(Hash)
        Table.new(arg.first.keys, &block).load(arg)
      else
        raise ArgumentError.new("Argument must be a string or an array of arrays or hashes")
      end
    end
  end
end