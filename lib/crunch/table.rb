require "crunch/table/aggregate"

module Crunch
  class Table
    include Enumerable
    include Aggregate

    attr_reader :headers, :table

    # Create a new Crunch::Table
    #
    # headers - Array of header names for the table
    # block   - Block evaluated in the context of the instance, for convenience
    #
    # Examples
    #
    #   table = Crunch::Table.new(["a", "b"]) do
    #     integer("a")
    #     date("b")
    #   end
    #   table.push(['1', '2011-01-01'])
    #
    # Returns an instance of Crunch::Table
    def initialize(headers, &block)
      @transforms = []
      @filters    = []
      @table      = CSV::Table.new([])
      @headers    = headers

      if block_given?
        block.arity == 1 ? yield(self) : instance_eval(&block)
      end

      self
    end

    extend Forwardable
    def_delegators :@table, :each, :first, :last, :[], :to_csv

    # Pushes a new row of data into the table. All data inserted into the
    # table must pass through this method or else transforms and filters
    # won't be applied.
    #
    # rows - A hash or array of data
    #
    # Examples
    #
    #   table.push(['1','2'])
    #   table.push(:a => '1', :b => '2')
    #
    # Returns the table for chaining
    def push(*rows)
      rows.each { |row| self << row }
      self
    end

    def <<(row)
      row = run_transforms( to_row(row) )
      @table << row unless filtered?(row)
    end

    def date(*cols)
      transform(*cols) { |c| Date.parse(c) }
    end

    def integer(*cols)
      transform(*cols, &:to_i)
    end

    def float(*cols)
      transform(*cols, &:to_f)
    end

    # With no args, block will be given the row.
    # With args, block will get called once for each column, and passed the
    # value of the that column. The value of the column will be replaced with
    # the return value of the block
    def transform(*cols, &block)
      cols.empty? ? transform_row(&block) : transform_cols(*cols, &block)
    end

    def filter(&block)
      @filters.push(block)
    end

    def filtered?(row)
      @filters.any? { |prc| prc.call(row) }
    end

    def to_s
      as(:str)
    end

    def as(format)
      Rendering.render(self, format)
    end

    def merge(*args,&block)
      merged_data = Hash.new

      # Loop through data sets
      args.unshift(self).each do |table|
        table.each do |row|
          key = yield(row)

          merged_data[key] = if merged_data[key].nil?
            row
          else
            merged_data[key].merge(row)
          end
        end
      end

      rows = merged_data.values.sort_by { |r| yield(r) }
      self.class.new(rows.first.keys).push(*rows)
    end

    private

    def to_row(array_or_hash)
      array_or_hash.is_a?(Array) ?
        Row.new(@headers, array_or_hash) :
        Row[array_or_hash]
    end

    def transform_cols(*cols, &block)
      @transforms += cols.map { |col| [block, col] }
    end

    def transform_row(&block)
      @transforms.push(block)
    end

    def run_transforms(row)
      @transforms.each do |(prc,col)|
        if col.nil?
          prc.call(row)
        else
          row[col] = prc.call(row[col])
        end
      end

      # If a new header was created by this transform, add it to the table
      @headers += (row.headers - @headers) if @headers != row.headers

      return row
    end
  end
end
