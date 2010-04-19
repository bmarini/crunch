module Crunch
  class Row < CSV::Row
    def self.[](hash)
      new(hash.keys, hash.values)
    end
  end
end