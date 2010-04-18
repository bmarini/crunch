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
        run_transforms(Row[@headers.zip(r)].methodize_keys!).methodize_keys!
      end
    end

    def from_hashes(data)
      @headers = data.first.keys
      @data    = data.map do |r|
        run_transforms(Row[r]).methodize_keys!
      end
    end
  end
end
