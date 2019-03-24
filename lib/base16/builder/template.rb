require "erb"
require "fileutils"

module Base16
  module Builder
    class Template
      attr_reader :name

      def self.find(name)
        file_path = Dir[File.join(Base16::Builder.templates_dir, "#{name}{,.*}.erb")].find { |f| File.file?(f) }

        unless file_path
          fail Error.new("No templates mathing name: #{name}")
        end

        new(file: file_path)
      end

      def initialize(file:)
        @file_path = file
        @file_extension = File.extname(File.basename(file, ".erb"))
        @name = File.basename(File.basename(file, ".erb"), ".*")
      end

      def render(scheme:)
        rendered_filename = "base16-#{scheme.slug}#{file_extension}"
        rendered_dir = File.join(output_dir, name)
        rendered_file_path = File.join(rendered_dir, rendered_filename)
        rendered_template = template.result_with_hash({ scheme: scheme })

        FileUtils.mkdir_p(rendered_dir)
        File.write(rendered_file_path, rendered_template)
      end

      private

      attr_reader :file_path
      attr_reader :file_extension

      def template
        @template ||= ERB.new(File.read(file_path))
      end

      def output_dir
        ENV.fetch("BASE16_BUILDER_OUTPUT_DIR", File.join(Dir.pwd, "out"))
      end
    end
  end
end
