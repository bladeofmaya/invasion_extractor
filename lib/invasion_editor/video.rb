module InvasionEditor
  # Starts the OCR process and handles metadata and caching
  class Video
    attr_reader :video, :tmpdir, :frame_data

    def self.run(video)
      new(video).process
    end

    def initialize(video)
      @video = video
      @tmpdir = File.join(Dir.tmpdir, "invasion_editor_#{Time.now.to_i}")
      FileUtils.mkdir_p(@tmpdir)
      @frame_data = []
    end

    def process
      if cached_data_exists?
        load_cached_data
      else
        generate_frames
        extract_text_from_images
        cleanup
        cache_data
      end
      self
    end

    private

    # This method generates frames from the video file and adds contrast and brightness to the frames.
    # TODO: Research if the process of character recognition can be improved by
    # reducing the aspect ratio of the frames. (e.g. 2560x1440 -> 1280x720)
    #
    def generate_frames
      # ffmpeg
      system("ffmpeg -i #{@video} -vf fps=2,eq=contrast=10:brightness=1.0 #{@tmpdir}/frame_%04d.jpg")

      # TODO: Test performance with different hardware acceleration options.
      # Would also save storage space.
      # system("ffmpeg -i #{@video} -c:v hevc_videotoolbox -profile:v main -vf fps=2,eq=contrast=10:brightness=1.0 #{@tmpdir}/frame_%04d.jpg")
      #
      # system(
      #   "ffmpeg",
      #   "-hwaccel", "videotoolbox",
      #   "-i", @video,
      #   "-vf", "fps=2,eq=contrast=10:brightness=1.0,format=yuv420p,colorspace=bt709:iall=bt709:fast=1",
      #   "-q:v", "3",
      #   "-strict", "unofficial",
      #   "-threads", "4",
      #   "#{@tmpdir}/frame_%04d.jpg"
      # )
    end

    def extract_text_from_images
      frames = Dir.glob("#{@tmpdir}/*.jpg").sort
      @frame_data = InvasionEditor::Ocr.run(frames, @video)
    end

    def cleanup
      FileUtils.rm_rf(@tmpdir)
    end

    def cache_file_path
      cache_dir = File.expand_path('../../tmp/ocr_cache', __dir__)
      FileUtils.mkdir_p(cache_dir)
      File.join(cache_dir, "#{video_hash}.yml")
    end

    def video_hash
      File.basename(@video)
    end

    def cached_data_exists?
      File.exist?(cache_file_path)
    end

    def load_cached_data
      cached_data = YAML.load_file(cache_file_path)
      @frame_data = cached_data.map do |item|
        InvasionEditor::Frame.new(item[:number], item[:text], item[:timestamp], item[:video_file])
      end
    end

    def cache_data
      data_to_cache = @frame_data.map do |frame|
        {
          number: frame.number,
          text: frame.text,
          timestamp: frame.timestamp,
          video_file: frame.video_file
        }
      end
      File.write(cache_file_path, data_to_cache.to_yaml)
    end

    def inspect
      frame_count = @frame_data.size
      first_frame = @frame_data.first
      last_frame = @frame_data.last

      "#<#{self.class}:#{object_id} " \
      "@video=\"#{@video}\", " \
      "@frame_data=[#{frame_count} frames, " \
      "first: #{first_frame&.timestamp}, " \
      "last: #{last_frame&.timestamp}]>"
    end

  end
end
