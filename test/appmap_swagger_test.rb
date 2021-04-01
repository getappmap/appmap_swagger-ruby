require "test_helper"

class AppmapSwaggerTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::AppMap::Swagger::VERSION
  end
end
