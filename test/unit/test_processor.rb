# frozen_string_literal: true

require "test_helper"

class TestProcessor < Minitest::Test

  def test_processor
    processor = InvasionEditor::Processor.new(["test/samples/invasion-sample-720p.mp4"])
  end
end
