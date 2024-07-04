require "test_helper"

class TestProcessor < Minitest::Test

  def test_processor
    processor = InvasionEditor::Processor.call(["test/samples/invasion-sample-720p.mp4"])

    binding.pry
  end
end
