module Crunch
  module Renderers
    class String
      def initialize(table)
        @table = table
        self
      end

      def maxes
        @maxes ||= begin
          mxs = @table.inject({}) do |m, r|
            r.each do |(h,f)|
              m[h] = [ f.to_s.length, m[h].to_i ].max
            end
            m
          end

          # Headers
          @table.headers.each do |h|
            mxs[h] = [ h.to_s.length, mxs[h] ].max
          end
          mxs
        end
      end

      def seperator
        "+-" + @table.headers.map { |h| "-" * maxes[h] }.join("-+-") + "-+"
      end

      def render
        puts seperator
        puts "| " + @table.headers.map { |h| h.to_s.ljust(maxes[h]) }.join(" | ") + " |"
        puts seperator
        @table.each do |row|
          puts "| " + row.map { |(h,f)| f.to_s.ljust(maxes[h]) }.join(" | ") + " |"
        end
        puts seperator
      end
    end
  end
end