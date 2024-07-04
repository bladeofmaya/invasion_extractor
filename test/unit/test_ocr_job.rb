# frozen_string_literal: true

require "test_helper"

class TestOcrJob < Minitest::Test
  def test_ocr_job
    video_path = "test/samples/invasion-sample-720p.mp4"

    frame_data = InvasionEditor::OcrJob.run(video_path)
  end
end
