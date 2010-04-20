module Crunch
  class Row < CSV::Row
    alias_method :keys, :headers
    alias_method :values, :fields

    def self.[](hash)
      new(hash.keys, hash.values)
    end

    def merge!(row)
      row.each do |key, value|
        self[key] = value
      end
    end
  end
end