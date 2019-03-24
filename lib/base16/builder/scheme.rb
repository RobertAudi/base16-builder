require "yaml"

module Base16
  module Builder
    class Scheme
      attr_reader :name
      attr_reader :author
      attr_reader :bases

      def self.find(name)
        file_path = File.join(SCHEMES_DIR, "#{name}.yaml")

        unless File.file?(file_path)
          fail Error.new("Scheme not found: #{name}")
        end

        new(file: file_path)
      end

      def initialize(file:)
        yaml = YAML.load_file(file, fallback: {}) || {}

        @author = yaml.fetch("author")
        @name = yaml.fetch("scheme")

        bases = (0...16).map { |n| format("base%02X", n) }
        @bases = bases.each_with_object({}) do |base, obj|
          obj[base] = yaml.fetch(base)
        end
      end

      def slug(separator: "-")
        name.gsub(/[^a-z0-9\-_]+/i, separator).downcase
      end
    end
  end
end
