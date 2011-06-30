module Crunch
  class Table
    class Aggregator
      def initialize(table, &block)
        @table       = table
        @aggregators = {}

        block.arity == 1 ? yield(self) : instance_eval(&block)
      end

      def group_by(col)
        @col_to_group_by = col
      end

      def sum(col)
        # @transforms.push
        @aggregators[col] = lambda { |vals| vals.inject(0) { |s,v| s + v } }
      end

      def to_aggregate
        agg_table = Table.new(@table.headers)

        groups = @table.group_by { |r| r[@col_to_group_by] }
        groups.each do |group, rows|
          agg_table << aggregate_values(rows)
        end

        agg_table
      end

      # TODO: Something a little more readable that doesn't require
      # comments to explain what is happening!
      def aggregate_values(rows)
        # Convert rows into hash where each key is a column name and the each
        # value is an array of values for that column
        cols = Hash.new { |h,k| h[k] = [] }
        cols = rows.inject(cols) do |hsh, row|
          row.each do |k,v|
            hsh[k] << v
          end
          hsh
        end

        # Loop through each column, applying an aggregate proc if one exists
        # to the array of column values. If a proc does not exist we take the
        # last value from the array.
        result = cols.inject({}) do |hsh, (col, vals)|
          hsh[col] = if @aggregators[col]
            @aggregators[col].call(vals)
          else
            vals.last
          end
          hsh
        end

        Row[result]
      end
    end

    module Aggregate
      def aggregate(&block)
        raise ArgumentError, "A block is required" unless block_given?
        aggregator = Aggregator.new(self, &block)
        aggregator.to_aggregate
      end
    end
  end
end
