require "test_helper"
class TestCrunchRendering < MiniTest::Unit::TestCase
  def test_render_to_string
    table = Crunch.table( File.expand_path("../data/test.csv", __FILE__) )
    # Crunch::Renderers::String.new(table).render
  end
end

