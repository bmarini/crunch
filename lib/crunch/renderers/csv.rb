module Crunch
  module Renderers
    class CSV
      def render
        @table.to_csv
      end
    end
  end
end