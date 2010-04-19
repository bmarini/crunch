module Crunch
  class Table
    include Enumerable
    attr_reader :headers, :table

    def initialize(headers, &block)
      @transforms = []
      @table      = CSV::Table.new([])
      @headers    = headers
      instance_eval &block if block_given?
      self
    end

    extend Forwardable
    def_delegators :@table, :each, :first, :last, :[]

    # Accepts a hash or array. All data inserted into the table must pass
    # through this method
    def push(*rows)
      rows.each { |row| self << row }
      self
    end

    def <<(row)
      @table << run_transforms( to_row(row) )
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

    def to_s
      as(:str)
    end

    def as(format)
      Rendering.render(self, format)
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

      return row
    end
  end
end
