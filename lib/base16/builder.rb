require "base16/builder/version"
require "base16/builder/scheme"
require "base16/builder/template"

module Base16
  module Builder
    class Error < StandardError; end

    SCHEMES_DIR = File.expand_path(File.join(__dir__, "..", "..", "share", "schemes"))
    TEMPLATES_DIR = File.expand_path(File.join(__dir__, "..", "..", "share", "templates"))
  end
end
