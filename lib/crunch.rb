require 'forwardable'
autoload :CSV, "csv"

module Crunch
  autoload :Table, "crunch/table"
  autoload :Row, "crunch/row"
  
  class << self
    # Convenience method to Crunch::Table.new
    def table(arg, &block)
      Table.new( arg.is_a?(String) ? CSV.read(arg) : arg, &block )
    end
  end
end