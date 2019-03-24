require "base16/builder/version"
require "base16/builder/scheme"
require "base16/builder/template"
require "base16/builder/collections"

module Base16
  module Builder
    class Error < StandardError; end

    SCHEMES_DIR = File.expand_path(File.join(__dir__, "..", "..", "share", "schemes"))
    TEMPLATES_DIR = File.expand_path(File.join(__dir__, "..", "..", "share", "templates"))

    def self.schemes_dir
      ENV.fetch("BASE16_BUILDER_SCHEMES_DIR", SCHEMES_DIR)
    end

    def self.templates_dir
      ENV.fetch("BASE16_BUILDER_TEMPLATES_DIR", TEMPLATES_DIR)
    end
  end
end
