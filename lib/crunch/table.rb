module Crunch
  class Table
    include Enumerable
    attr_reader :headers, :data

    def initialize(data,&block)
      @transforms = []
      instance_eval(&block) if block_given?

      if data.first.is_a?(Array)
        from_arrays(data)
      elsif data.first.is_a?(Hash)
        from_hashes(data)
      else
        raise ArguementError.new("data must be an array of arrays or hashes")
      end

    end

    extend Forwardable
    def_delegators :@data, :each, :first, :last, :[]

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

    def from_arrays(data)
      @headers = data.shift
      @data    = data.map do |r|
        run_transforms Row[@headers.zip(r)]
      end
    end

    def from_hashes(data)
      @headers = data.first.keys
      @data    = data.map do |r|
        run_transforms Row[r]
      end
    end
  end
end
