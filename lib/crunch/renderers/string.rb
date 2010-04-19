module Crunch
  module Renderers
    class String
      def initialize(table)
        @table = table
        self
      end

      def maxes
        @maxes ||= begin
          mxs = @table.inject([]) do |m, r|
            @table.headers.each_with_index do |k, i|
              m[i] = [ r[k].to_s.length, m[i].to_i ].max
            end
            m
          end

          # Headers
          @table.headers.each_with_index do |h, i|
            mxs[i] = [ h.to_s.length, mxs[i] ].max
          end
          mxs
        end
      end

      def render
        sep = "+-" + maxes.map { |m| "-" * m }.join("-+-") + "-+"

        puts sep
        puts "| " + @table.headers.enum_for(:each_with_index).map { |h, i|
                      h.to_s.ljust(maxes[i])
                    }.join(" | ") + " |"
        
        puts sep
        @table.each do |row|
          puts "| " + @table.headers.enum_for(:each_with_index).map { |h, i|
                        row[h].to_s.ljust(maxes[i])
                      }.join(" | ") + " |"
        end
        puts sep
      end
    end
  end
end