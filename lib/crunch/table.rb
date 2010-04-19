module Crunch
  class Table
    include Enumerable
    attr_reader :headers, :data

    def initialize(headers, &block)
      @transforms = []
      @data       = []
      @headers    = headers
      instance_eval &block if block_given?
      self
    end

    extend Forwardable
    def_delegators :@data, :each, :first, :last, :[]

    # Accepts a hash or array. All data inserted into the table must pass
    # through this method
    def push(row)
      @data << run_transforms( to_row(row) )
    end
    alias_method :<<, :push

    def unshift(row)
      @data.unshift run_transforms( to_row(row) )
    end

    def load(rows)
      rows.each { |r| push(r) }; self # For chaining onto #new
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

    private

    def to_row(array_or_hash)
      array_or_hash.is_a?(Array) ?
        Row[@headers.zip(array_or_hash)] :
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
