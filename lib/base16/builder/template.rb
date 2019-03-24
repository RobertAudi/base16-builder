require "erb"
require "fileutils"

module Base16
  module Builder
    class Template
      attr_reader :name

      def self.find(name)
        file_path = Dir[File.join(TEMPLATES_DIR, "#{name}{,.*}.erb")].find { |f| File.file?(f) }

        unless file_path
          fail Error.new("No templates mathing name: #{name}")
        end

        new(file: file_path)
      end

      def initialize(file:)
        @file_path = file
        @file_extension = File.extname(File.basename(file, ".erb"))
        @name = File.basename(File.basename(file, ".erb"), ".*")
        @template = ERB.new(File.read(file))
      end

      def render(scheme:)
        rendered_filename = "base16-#{scheme.slug}#{@file_extension}"
        rendered_dir = "out/#{@name}"
        rendered_template = @template.result_with_hash({ scheme: scheme })

        FileUtils.mkdir_p(rendered_dir)
        File.write("#{rendered_dir}/#{rendered_filename}", rendered_template)
      end
    end
  end
end
