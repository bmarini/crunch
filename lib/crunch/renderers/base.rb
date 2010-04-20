module Crunch
  module Renderers
    class Base
      def initialize(table)
        @table = table
      end

      def render
        # Implement in subclass
      end
    end
  end
end