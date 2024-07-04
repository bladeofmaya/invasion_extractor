# frozen_string_literal: true
require 'yaml'
require 'pry'
require 'fileutils'
require 'json'
require 'yaml'
require 'digest'
require 'tmpdir'
require 'time'

require_relative "helpers/time_shifter"

require_relative "invasion_editor/frame"
require_relative "invasion_editor/clip"
require_relative "invasion_editor/video"
require_relative "invasion_editor/ocr"
require_relative "invasion_editor/processor"
require_relative "invasion_editor/invasion_scanner"
require_relative "invasion_editor/version"

module InvasionEditor
  class Error < StandardError; end
end
