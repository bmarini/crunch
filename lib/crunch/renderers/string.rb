module Crunch
  module Renderers
    class String < Base
      def render
        puts seperator
        puts "| " + @table.headers.map { |h| h.to_s.ljust(maxes[h]) }.join(" | ") + " |"
        puts seperator
        @table.each do |row|
          puts "| " + @table.headers.map { |h| row[h].to_s.ljust(maxes[h]) }.join(" | ") + " |"
        end
        puts seperator
      end

      def maxes
        @maxes ||= begin
          mxs = Hash.new { |h,k| h[k] = 0 }
          @table.each do |r|
            r.each do |(h,f)|
              mxs[h] = [ f.to_s.length, mxs[h] ].max
            end
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
    end
  end
end