module Crunch
  module Renderers
    class JSON < Base
      def render
        MultiJson.encode( @table.map { |r| r.to_hash } )
      end
    end
  end
end