module Crunch
  class Rendering
    RENDERERS = {
      :string => Crunch::Renderers::String,
      :str    => Crunch::Renderers::String
    }

    def self.render(table, format)
      RENDERERS[format].new(table).render
    end
  end
end