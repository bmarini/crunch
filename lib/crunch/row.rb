module Crunch
  class Row < CSV::Row
    alias_method :keys, :headers
    alias_method :values, :fields

    def self.[](hash)
      new(hash.keys, hash.values)
    end

    def merge(row)
      self.class.new(keys, values).merge!(row)
    end

    def merge!(row)
      row.each do |key, value|
        self[key] = value
      end
      self
    end

    def to_ary
      row
    end
  end
end